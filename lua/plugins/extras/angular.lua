return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "angular", "html", "typescript", "tsx" })
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
        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
        root_dir = require("lspconfig.util").root_pattern("angular.json", "nx.json"),
        single_file_support = false,
        on_new_config = function(new_config, new_root_dir)
          new_config.settings = vim.tbl_extend("force", new_config.settings or {}, {
            angular = { suggest = { standalone = false, strictInputTypes = true } },
          })
        end,
      }
    end,
  },
}
