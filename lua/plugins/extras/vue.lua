return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vue" })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vue-language-server" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.volar = {
        filetypes = { "vue", "typescript", "javascript" },
        root_dir = require("lspconfig.util").root_pattern("package.json", "vue.config.js"),
        single_file_support = false,
        init_options = {
          typescript = { tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib" },
        },
        settings = {
          volar = {
            codeLens = { references = true, pugTools = true, scriptSetupTools = true },
          },
        },
        on_attach = function(client, bufnr)
          if ByteVim.deno_config_exist() then
            ByteVim.stop_lsp_client_by_name("volar")
          end
        end,
      }
    end,
  },
}
