return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "jsonls",
        "angularls",
        "marksman",
        "cssls",
        "html",
        "prismals",
        "yamlls",
        "vue-language-server",
        "gopls",
        "denols",
      },
      automatic_installation = true,
    },
    handlers = {},
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-org/mason-lspconfig.nvim",
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
                library = { "${3rd}/luv/library", unpack(vim.api.nvim_get_runtime_file("", true)) },
              },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        pyright = {},
        jsonls = {},
        prismals = { filetypes = { "prisma" }, settings = { prisma = { prismaFmtBinPath = "prisma-fmt" } } },
        marksman = {},
        cssls = {},
        html = { filetypes = { "html", "twig", "hbs" } },
        ruby_lsp = {},
        angularls = {
          filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
          root_dir = require("lspconfig.util").root_pattern("angular.json", "nx.json"),
          single_file_support = false,
          on_new_config = function(new_config, new_root_dir)
            new_config.settings = vim.tbl_extend("force", new_config.settings or {}, {
              angular = { suggest = { standalone = false, strictInputTypes = true } },
            })
          end,
        },
      },
      inlay_hints = { enabled = true },
    },
    config = function(_, opts)
      require("lsp").setup(opts)
      require("lsp_keymaps").setup_keymaps()
    end,
  },
}
