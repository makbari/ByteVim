local ts_filetypes = { "javascript", "typescript", "typescriptreact", "svelte" }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },
  -- Translate TypeScript errors into a more readable format
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = ts_filetypes,
    opts = {
      auto_override_publish_diagnostics = true,
    },
  },
  -- Enable twoslash queries for inline type information
  {
    "marilari88/twoslash-queries.nvim",
    ft = ts_filetypes,
    opts = {
      is_enabled = false, -- Disabled by default, toggle with keybinding
      multi_line = true, -- Support multi-line queries
      highlight = "Type", -- Use 'Type' highlight group for query results
    },
    keys = {
      { "<leader>dt", ":TwoslashQueriesEnable<cr>", desc = "Enable twoslash queries" },
      { "<leader>dd", ":TwoslashQueriesInspect<cr>", desc = "Inspect twoslash queries" },
    },
  },
}
