return {
  {
    "pmizio/typescript-tools.nvim",
    cond = function()
      return ByteVim.lsp.get_config_path("package.json") ~= nil
    end,
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "literals",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "javascript", "typescript", "typescriptreact", "svelte" },
    opts = {
      auto_override_publish_diagnostics = true,
    },
  },
  {
    "marilari88/twoslash-queries.nvim",
    ft = { "javascript", "typescript", "typescriptreact", "svelte" },
    opts = { is_enabled = false, multi_line = true, highlight = "Type" },
    keys = {
      { "<leader>dt", ":TwoslashQueriesEnable<cr>", desc = "Enable twoslash queries" },
      { "<leader>dd", ":TwoslashQueriesInspect<cr>", desc = "Inspect twoslash queries" },
    },
  },
}
