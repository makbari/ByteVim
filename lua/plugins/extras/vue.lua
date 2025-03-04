return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vuels = {
          on_attach = function(client, bufnr)
            require("utils.lsp").on_attach(client, bufnr)
          end,
        },
      },
    },
  },
}
