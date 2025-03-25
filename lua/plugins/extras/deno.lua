return {
  {
    "sigmaSd/deno-nvim",
    cond = function()
      return ByteVim.lsp.deno_config_exist()
    end,
    config = function()
      require("deno-nvim").setup({
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
      })
    end,
  },
}
