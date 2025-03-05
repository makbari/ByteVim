local lsp_utils = require("utils.lsp")
return {
  -- Lazydev for Lua LSP
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },

  -- Mason for managing tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua", -- Lua formatter
        "shfmt", -- Shell formatter
      },
    },
  },

  -- Mason-LSPConfig for automatic LSP setup
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ruff",
        "gopls",
        "html",
        "cssls",
        "dockerls",
        "terraformls",
        "prismals",
        "jsonls",
        "yamlls",
        "docker_compose_language_service", -- Corrected name
        "vuels",
        "svelte",
        "ts_ls",
      },
      automatic_installation = true, -- Automatically install LSP servers
    },
  },

  -- LSPConfig for configuring LSP servers
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- Load LSP before opening files
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
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
              codeLens = { enable = true },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        pyright = {},
        ruff = {},
        html = { filetypes = { "html", "twig", "hbs" } },
        cssls = {},
        dockerls = {},
        terraformls = {},
        prismals = {},
        jsonls = {},
        yamlls = {},
        docker_compose_language_service = {},
        vuels = {},
        svelte = {},
        ts_ls = {},
      },
      inlay_hints = { enabled = true },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local mason_lspconfig = require("mason-lspconfig")
      -- Setup all servers
      local options = vim.tbl_deep_extend("force", {
        servers = {},
        inlay_hints = { enabled = true },
        setup = {},
      }, opts or {})
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(options.servers), -- Automatically install listed servers
        automatic_installation = true,
      })
      mason_lspconfig.setup_handlers({
        function(server_name)
          if server_name == "ts_ls" or server_name == "denols" then
            lsp_utils.setup_typescript_lsp(capabilities)
          else
            lspconfig[server_name].setup({
              capabilities = capabilities,
              on_attach = lsp_utils.on_attach,
              root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd()),
            })
          end
        end,
      })

      -- Initialize workspace for all servers at startup
      for _, server_name in ipairs(options.servers) do
        local config = lspconfig[server_name]
        if config and config.manager then
          config.manager.try_add(vim.fn.getcwd())
        end
      end
    end,
  },
}
