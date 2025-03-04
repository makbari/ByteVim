return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {
          on_attach = function(client, bufnr)
            require("utils.lsp").on_attach(client, bufnr)
          end,
        },
      },
    },
  },
}
