return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vue" })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vuels" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.vuels = {
        filetypes = { "vue" },
        root_dir = require("lspconfig.util").root_pattern(
          "vue.config.js",
          "vue.config.ts",
          "vue.config.mjs",
          "nuxt.config.js",
          "nuxt.config.ts",
          "nuxt.config.mjs"
        ),
        single_file_support = false,
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
        settings = {
          vue = {
            updateImportsOnFileMove = { enabled = true },
            inlayHints = {
              inlineHandlerLeading = { enabled = true },
              optionsWrapper = { enabled = true },
            },
          },
        },
      }
    end,
  },
}
