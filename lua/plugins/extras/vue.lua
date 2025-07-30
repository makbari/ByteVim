return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    servers = {
      volar = {
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
      },
    },
  },
}
