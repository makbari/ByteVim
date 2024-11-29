return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = "javascript,typescript,typescriptreact,svelte",
    opts = {
      auto_override_publish_diagnostics = true,
    },
  },
  {
    "marilari88/twoslash-queries.nvim",
    ft = "javascript,typescript,typescriptreact,svelte",
    opts = { is_enabled = false, multi_line = true, highlight = "Type" },
    keys = {
      { "<leader>dt", ":TwoslashQueriesEnable<cr>", desc = "Enable twoslash queries" },
      { "<leader>dd", ":TwoslashQueriesInspect<cr>", desc = "Inspect twoslash queries" },
    },
  },
}
