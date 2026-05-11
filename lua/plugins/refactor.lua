return {
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
    config = function()
      vim.keymap.set("n", "<leader>rn", "<cmd>IncRename<CR>")
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>S", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      autofold_depth = 1,
      keymaps = {
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_all = "W",
        unfold_all = "E",
        fold_reset = "R",
      },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
      {
        "<leader>rm",
        function()
          require("refactoring").select_refactor()
        end,
        mode = { "v" },
        desc = "Refactoring menu",
      },
      {
        "<leader>dv",
        function()
          require("refactoring").debug.print_var({ below = true })
        end,
        mode = { "n", "x" },
        desc = "Print below variables",
      },
      {
        "<leader>dV",
        function()
          require("refactoring").debug.print_var({ below = false })
        end,
        mode = { "n", "x" },
        desc = "Print above variables",
      },
      {
        "<leader>dc",
        function()
          require("refactoring").debug.cleanup({ force = true })
        end,
        desc = "Clear debugging",
      },
    },
    opts = {
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
    },
    config = function(_, options)
      require("refactoring").setup(options)
    end,
  },
}
