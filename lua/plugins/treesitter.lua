return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    branch = "master",
    event = { "BufReadPost", "BufWritePost" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<BS>", desc = "Decrement Selection", mode = "x" },
      { "]p", desc = "Next property/parameter", mode = "n" },
      { "[p", desc = "Previous property/parameter", mode = "n" },
      { "]m", desc = "Next method/function", mode = "n" },
      { "[m", desc = "Previous method/function", mode = "n" },
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
        "go",
        "gomod",
        "gowork",
        "rust",
        "ron",
        "ruby",
        "embedded_template",
        "git_config",
        "gitcommit",
        "git_rebase",
        "gitignore",
        "gitattributes",
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
            ["ap"] = { query = "@parameter.outer", desc = "Around parameter/property" },
            ["ip"] = { query = "@parameter.inner", desc = "Inside parameter/property" },
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]v"] = "@variable.outer",
            ["]s"] = "@scope",
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
            ["]t"] = "@tag.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
            ["]T"] = "@tag.outer",
          },
          goto_previous_start = {
            ["[v"] = "@variable.outer",
            ["[s"] = "@scope",
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
            ["[t"] = "@tag.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
            ["[T"] = "@tag.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sn"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>sp"] = "@parameter.inner",
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
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  },

  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPost",
    opts = {},
  },
}
