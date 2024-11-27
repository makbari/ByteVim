return {
    {
      "nvim-treesitter/nvim-treesitter",
      version = false,
      build = ":TSUpdate",
      event = { "BufReadPost", "BufWritePost" },
      cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
      keys = {
        { "<C-space>", desc = "Increment Selection" },
        { "<BS>", desc = "Decrement Selection", mode = "x" },
      },
      opts = {
        highlight = { enable = true },
        indent = { enable = true },
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
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            node_decremental = "<BS>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner",
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
  