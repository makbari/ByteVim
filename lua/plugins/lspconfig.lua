return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    config = true,
    version = "^1",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "jsonls",
        "marksman",
        "cssls",
        "html",
        "prismals",
        "yamlls",
        "gopls",
      },
      automatic_installation = false,
    },
    version = "^1",
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      return {
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                  library = {
                    "${3rd}/luv/library",
                    unpack(vim.api.nvim_get_runtime_file("", true)),
                  },
                },
                completion = { callSnippet = "Replace" },
              },
            },
          },
          pyright = {},
          jsonls = {},
          prismals = {
            filetypes = { "prisma" },
            settings = { prisma = { prismaFmtBinPath = "prisma-fmt" } },
          },
          marksman = {},
          cssls = {},
          html = { filetypes = { "html", "twig", "hbs" } },
          ruby_lsp = {},
        },
        inlay_hints = { enabled = true },
      }
    end,
    config = function(_, opts)
      ByteVim.lsp.on_attach(function(client, bufnr)
        if opts.inlay_hints.enabled and client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end)

      ByteVim.lsp_keymaps.setup_keymaps()

      ByteVim.lsp.disable("denols", function(root_dir)
        return not ByteVim.deno_config_exist()
      end)

      ByteVim.lsp.disable("vtsls", function(root_dir)
        return ByteVim.deno_config_exist()
      end)

      ByteVim.lsp.disable("volar", function(root_dir)
        return ByteVim.deno_config_exist()
      end)

      ByteVim.lsp.disable("angularls", function(root_dir)
        return ByteVim.deno_config_exist()
      end)

      local servers = opts.servers

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        require("lspconfig")[server].setup(server_opts)
      end

      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}

      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = ensure_installed,
          handlers = { setup },
        })
      end
    end,
  },
}
