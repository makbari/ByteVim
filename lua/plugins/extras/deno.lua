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
          on_attach = function(client, bufnr)
            ByteVim.lsp.stop_lsp_client_by_name("vtsls")
          end,
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

