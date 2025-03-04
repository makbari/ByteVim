return {
  {
    "sigmaSd/deno-nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          deno = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      },
    },
    cond = function()
      return ByteVim.lsp.deno_config_exist()
    end,
  },
}
