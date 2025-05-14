return {
  {
    "pmizio/typescript-tools.nvim",
    cond = function()
      return ByteVim.lsp.get_config_path("package.json") ~= nil and not ByteVim.lsp.deno_config_exist()
    end,
    opts = {
      on_attach = function(client, bfr)
        if ByteVim.lsp.deno_config_exist() then
          ByteVim.lsp.stop_lsp_client_by_name("ts_ls")
          client.stop()
          return false
        end
      end,
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
