return {
  -- Snippet engine (used by neogen)
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = (function()
      if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
        return nil
      end
      return "make install_jsregexp"
    end)(),
  },
  -- Auto Completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- Use the latest version
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      { "petertriho/cmp-git", opts = {} },
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "crates" })
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local auto_select = true
      return {
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-a>"] = cmp.mapping.complete(), -- Manually trigger completion menu
          ["<CR>"] = cmp.mapping.confirm({ select = auto_select, behavior = cmp.ConfirmBehavior.Replace }), -- Confirm selection
          ["<C-e>"] = cmp.mapping.close(), -- Close completion menu
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP-based completions
          { name = "path" }, -- Path completions
        }, {
          { name = "buffer" }, -- Buffer-based completions
        }),
        formatting = {
          format = function(entry, item)
            local icons = require("config.icons").kind
            if icons[item.kind] then
              item.kind = icons[item.kind] .. " " .. item.kind
            end
            local ok, tw = pcall(require, "tailwind-tools.cmp")
            if ok then
              item = require("lspkind").cmp_format({ before = tw.lspkind_format })(entry, item)
            end
            return item
          end,
        },
        experimental = {
          ghost_text = true, -- Show ghost text in the completion menu
        },
        sorting = defaults.sorting,
      }
    end,
  },
  -- Auto Pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
    },
  },

  -- Comments
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Better Text-Objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        },
      }
    end,
  },
  {
    -- JsDoc generator
    {
      "heavenshell/vim-jsdoc",
      ft = "javascript,typescript,typescriptreact,svelte",
      cmd = "JsDoc",
      keys = {
        { "<leader>jd", "<cmd>JsDoc<cr>", desc = "JsDoc" },
      },
      -- make sure that you will have lehre install locally on plugin folder, refer https://github.com/heavenshell/vim-jsdoc#manual-installation
      build = "make install",
    },
    -- better code annotation
    {
      "danymat/neogen",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "L3MON4D3/LuaSnip",
      },
      config = function()
        local neogen = require("neogen")

        neogen.setup({
          snippet_engine = "luasnip",
          languages = {
            python = { template = { annotation_convention = "google_docstrings" } },
            lua = { template = { annotation_convention = "emmylua" } },
            markdown = { template = { annotation_convention = "md" } }, -- For notes!
          },
        })
      end,
      keys = {
        {
          "<leader>ng",
          function()
            require("neogen").generate()
          end,
          desc = "Generate code annotations",
        },
        {
          "<leader>nf",
          function()
            require("neogen").generate({ type = "func" })
          end,
          desc = "Generate Function Annotation",
        },
        {
          "<leader>nt",
          function()
            require("neogen").generate({ type = "type" })
          end,
          desc = "Generate Type Annotation",
        },
      },
    },
  },

  {
    {
      "numToStr/Comment.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
      config = function()
        local comment = require("Comment")
        local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
        comment.setup({
          pre_hook = ts_context_commentstring.create_pre_hook(),
        })
      end,
    },
  },
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    config = function()
      require("mini.move").setup({
        mappings = {
          left = "<A-h>",
          right = "<A-l>",
          down = "<A-j>",
          up = "<A-k>",
          line_left = "<A-h>",
          line_right = "<A-l>",
          line_down = "<A-j>",
          line_up = "<A-k>",
        },
        options = {
          reindent_linewise = true,
        },
      })
    end,
  },
  {
    "echasnovski/mini.surround",
    opts = {},
  },
  -- {
  --   "nvim-neorg/neorg",
  --   lazy = false,
  --   version = "*",
  --   config = true,
  -- },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "css", "scss", "javascript", "html", "lua", "vim" },
      user_default_options = {
        mode = "background",
        names = false,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        tailwind = false,
      },
    },
  },
}
