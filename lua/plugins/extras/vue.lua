return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vue", "typescript", "javascript" })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "volar" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.volar = {
        filetypes = { "vue", "typescript", "javascript" },
        root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
        single_file_support = false,
        init_options = {
          vue = {
            hybridMode = false, -- Use volar for Vue 3
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
        on_attach = function(client, bufnr)
          if ByteVim.lsp.deno_config_exist() then
            client.stop()
          end
        end,
      }
    end,
  },
}
