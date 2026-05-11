return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "toml",
        "typescript",
        "yaml",
        "tsx",
        "svelte",
        "rust",
        "go",
        "gomod",
        "gowork",
        "ron",
        "ruby",
        "embedded_template",
        "git_config",
        "gitcommit",
        "git_rebase",
        "gitignore",
        "gitattributes",
      },
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.setup({})

      local installed = ts.get_installed("parsers")
      local missing = vim.tbl_filter(function(p)
        return not vim.tbl_contains(installed, p)
      end, opts.ensure_installed or {})
      if #missing > 0 then
        ts.install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      local select = require("nvim-treesitter-textobjects.select").select_textobject
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")
      local map = vim.keymap.set

      map({ "x", "o" }, "<leader>at", function()
        select("@tag.outer", "textobjects")
      end, { desc = "Select around JSX tag" })
      map({ "x", "o" }, "<leader>it", function()
        select("@tag.inner", "textobjects")
      end, { desc = "Select inside JSX tag" })
      map({ "x", "o" }, "ap", function()
        select("@parameter.outer", "textobjects")
      end, { desc = "Around parameter/property" })
      map({ "x", "o" }, "ip", function()
        select("@parameter.inner", "textobjects")
      end, { desc = "Inside parameter/property" })

      map({ "n", "x", "o" }, "]v", function()
        move.goto_next_start("@variable.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "]s", function()
        move.goto_next_start("@scope", "textobjects")
      end)
      map({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "]a", function()
        move.goto_next_start("@parameter.inner", "textobjects")
      end)
      map({ "n", "x", "o" }, "]t", function()
        move.goto_next_start("@tag.outer", "textobjects")
      end)

      map({ "n", "x", "o" }, "]F", function()
        move.goto_next_end("@function.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "]C", function()
        move.goto_next_end("@class.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "]A", function()
        move.goto_next_end("@parameter.inner", "textobjects")
      end)
      map({ "n", "x", "o" }, "]T", function()
        move.goto_next_end("@tag.outer", "textobjects")
      end)

      map({ "n", "x", "o" }, "[v", function()
        move.goto_previous_start("@variable.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "[s", function()
        move.goto_previous_start("@scope", "textobjects")
      end)
      map({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "[a", function()
        move.goto_previous_start("@parameter.inner", "textobjects")
      end)
      map({ "n", "x", "o" }, "[t", function()
        move.goto_previous_start("@tag.outer", "textobjects")
      end)

      map({ "n", "x", "o" }, "[F", function()
        move.goto_previous_end("@function.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "[C", function()
        move.goto_previous_end("@class.outer", "textobjects")
      end)
      map({ "n", "x", "o" }, "[A", function()
        move.goto_previous_end("@parameter.inner", "textobjects")
      end)
      map({ "n", "x", "o" }, "[T", function()
        move.goto_previous_end("@tag.outer", "textobjects")
      end)

      map("n", "<leader>sn", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap next parameter/prop" })
      map("n", "<leader>sp", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap previous parameter/prop" })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPost",
    opts = {},
  },
}
