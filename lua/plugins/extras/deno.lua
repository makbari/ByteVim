return {
  {
    "sigmaSd/deno-nvim",
    dependencies = { "neovim/nvim-lspconfig" }, -- Assuming lspconfig is needed
    config = function()
      require("deno-nvim").setup({
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()), -- Assuming you're using cmp for capabilities
          settings = {
            deno = {
              inlayHints = {
                parameterNames = {
                  enabled = "all",
                },
                parameterTypes = {
                  enabled = true,
                },
                variableTypes = {
                  enabled = true,
                },
                propertyDeclarationTypes = {
                  enabled = true,
                },
                functionLikeReturnTypes = {
                  enabled = true,
                },
                enumMemberValues = {
                  enabled = true,
                },
              },
            },
          },
        },
      })
    end,
    cond = function()
      return ByteVim.lsp.deno_config_exist()
    end,
  },
}
