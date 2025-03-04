-- ~/.config/nvim/lua/plugins/extras/svelte.lua

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {
          on_attach = function(client, bufnr)
            require("utils.lsp").on_attach(client, bufnr)
          end,
        },
      },
    },
  },
}
