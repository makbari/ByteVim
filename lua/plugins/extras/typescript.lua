return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    servers = {
      vtsls = {
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            preferences = {
              importModuleSpecifier = "non-relative",
              jsxAttributeCompletionStyle = "auto",
            },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            preferences = {
              importModuleSpecifier = "non-relative",
              jsxAttributeCompletionStyle = "auto",
            },
          },
        },
      },
    },
    inlay_hints = { enabled = false },
    setup = {},
  },
}

