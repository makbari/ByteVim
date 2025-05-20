return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufWritePost" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<BS>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      matchup = { enable = true },
      auto_install = true,
      ensure_installed = {
        "bash",
        "c",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "typescript",
        "yaml",
        "tsx",
        "svelte",
        "rust",
        "go", "gomod", "gowork",
        "rust", "ron"
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_decremental = "<BS>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,

          keymaps = {
            ["<leader>at"] = { query = "@tag.outer", desc = "Select around JSX tag" },
            ["<leader>it"] = { query = "@tag.inner", desc = "Select inside JSX tag" },
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
            ["]t"] = "@tag.outer", -- JSX/HTML tag
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
            ["]T"] = "@tag.outer", -- JSX/HTML tag
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
            ["[t"] = "@tag.outer", -- JSX/HTML tag
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
            ["[T"] = "@tag.outer", -- JSX/HTML tag
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufReadPost",
    config = function()
      local ts_config = require("nvim-treesitter.configs").get_module("textobjects")
      if ts_config then
        require("nvim-treesitter.configs").setup({
          textobjects = ts_config.textobjects,
        })
      end
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPost",
    opts = {},
  },
}
