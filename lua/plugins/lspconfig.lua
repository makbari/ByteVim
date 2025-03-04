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
        "html",
        "cssls",
        "dockerls",
        "terraformls",
        "prismals",
        "jsonls",
        "yamlls",
        "docker-compose-language-service",
        "vue-language-server",
        "svelte",
        "ts_ls",
      },
      automatic_installation = true, -- Automatically install LSP servers
    },
  },

  -- LSPConfig for configuring LSP servers
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
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
        ["docker-compose-language-service"] = {},
        ["vue-language-server"] = {},
        svelte = {},
        ts_ls = {},
      },
      inlay_hints = { enabled = true },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup(opts.servers[server_name] or {})
        end,
      })
      ByteVim.lsp.setup(opts)
      ByteVim.lsp_keymaps.setup_keymaps()
    end,
  },
}
