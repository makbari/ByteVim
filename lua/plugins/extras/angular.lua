return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "typescript", "html", "css" })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "angularls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.angularls = {
        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
        root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json", ".git"),
        single_file_support = false,
        on_attach = function(client, bufnr)
          if ByteVim.lsp.deno_config_exist() then
            client.stop()
          end
        end,
        settings = {
          angular = {
            experimental = {
              ivy = true, -- Enable Ivy support
            },
            provideWorkspaceSymbols = true,
          },
        },
      }
    end,
  },
}
