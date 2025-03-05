return {
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>er", ":Neotree reveal float<CR>", silent = true, desc = "Reveal Float File Explorer" },
      { "<leader><Tab>", ":Neotree toggle left<CR>", silent = true, desc = "Left File Explorer" },
    },
    config = function()
      require("neo-tree").setup({
        add_blank_line_at_top = false, -- Add a blank line at the top of the tree.
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        enable_git_status = true,
        enable_modified_markers = true,
        popup_border_style = "single",
        sort_case_insensitive = true,
        window = { position = "float", width = 35 },
        default_component_configs = {
          indent = {
            with_markers = true,
            with_expanders = true,
          },
          modified = {
            symbol = " ",
            highlight = "NeoTreeModified",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            folder_empty_open = "",
          },
          git_status = {
            symbols = {
              -- Change type
              added = "",
              deleted = "",
              modified = "",
              renamed = "",
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = "",
            },
          },
        },
        event_handlers = {
          {
            event = "neo_tree_window_after_open",
            handler = function(args)
              if args.position == "left" or args.position == "right" then
                vim.cmd("wincmd =")
              end
            end,
          },
          {
            event = "neo_tree_window_after_close",
            handler = function(args)
              if args.position == "left" or args.position == "right" then
                vim.cmd("wincmd =")
              end
            end,
          },
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
          group_empty_dirs = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            -- hide_by_name = {
            --   "node_modules",
            -- },
            never_show = {
              ".DS_Store",
              "thumbs.db",
            },
          },
        },
      })
    end,
  },

  -- Search and Replace
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({ transient = true, prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil } })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  -- Which-Key for Keymap Discovery
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader><tab>", group = "tabs" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        { "<leader>b", group = "buffer" },
        { "<leader>w", group = "windows" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
    },
  },

  -- Git Blame Integration
  {
    "f-person/git-blame.nvim",
    cmd = {
      "GitBlameToggle",
      "GitBlameEnable",
      "GitBlameOpenCommitURL",
      "GitBlameCopyCommitURL",
      "GitBlameOpenFileURL",
      "GitBlameCopyFileURL",
      "GitBlameCopySHA",
    },
    keys = {
      { "<leader>gB", "<cmd>GitBlameOpenCommitURL<cr>", desc = "GitBlame | Open Commit Url" },
      { "<leader>gc", "<cmd>GitBlameCopyCommitURL<cr>", desc = "GitBlame | Copy Commit Url" },
      { "<leader>gf", "<cmd>GitBlameOpenFileURL<cr>", desc = "GitBlame | Open File Url" },
      { "<leader>gC", "<cmd>GitBlameCopyFileURL<cr>", desc = "GitBlame | Copy File Url" },
      { "<leader>gs", "<cmd>GitBlameCopySHA<cr>", desc = "GitBlame | Copy SHA" },
      { "<leader>gt", "<cmd>GitBlameToggle<cr>", desc = "GitBlame | Toggle Blame" },
    },
    opts = {},
  },

  -- Git Signs for Hunk Management
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
    keys = {
      {
        "]h",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end,
        desc = "Next Hunk",
      },
      {
        "[h",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end,
        desc = "Prev Hunk",
      },
      { "<leader>ghs", ":Gitsigns stage_hunk<CR>", mode = { "n", "v" }, desc = "Stage Hunk" },
      { "<leader>ghr", ":Gitsigns reset_hunk<CR>", mode = { "n", "v" }, desc = "Reset Hunk" },
      {
        "<leader>ghS",
        function()
          require("gitsigns").stage_buffer()
        end,
        desc = "Stage Buffer",
      },
      {
        "<leader>ghu",
        function()
          require("gitsigns").stage_hunk()
        end,
        desc = "Undo Stage Hunk",
      },
      {
        "<leader>ghR",
        function()
          require("gitsigns").reset_buffer()
        end,
        desc = "Reset Buffer",
      },
      {
        "<leader>ghp",
        function()
          require("gitsigns").preview_hunk_inline()
        end,
        desc = "Preview Hunk Inline",
      },
      {
        "<leader>ghb",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Blame Line",
      },
    },
  },

  -- Diffview for Git Diffs
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        "<leader>dfv",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "Toggle Diffview",
      },
    },
    event = "BufReadPost",
  },

  -- Better Escape Mapping
  { "max397574/better-escape.nvim", event = "InsertEnter", opts = {} },

  -- Fzf-lua for Fuzzy Finding
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons", "neovim/nvim-lspconfig" },
    opts = {
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.35,
        col = 0.55,
        preview = { layout = "flex", flip_columns = 130, scrollbar = "float" },
      },
      files = { multiprocess = true, git_icons = false, file_icons = false },
      grep = { multiprocess = true },
    },
    keys = {
      { "<C-g>", "<cmd>FzfLua grep_project<CR>", desc = "Find Grep" },
      {
        "<leader>fr",
        function()
          require("fzf-lua").oldfiles({ cwd = ByteVim.path.git() })
        end,
        desc = "Find Recent Files",
      },
      {
        "<leader>/",
        function()
          require("fzf-lua").live_grep({ cwd = ByteVim.path.root(), multiprocess = true })
        end,
        desc = "Grep Files at Current Directory",
      },
      {
        "<leader>ff",
        function()
          require("fzf-lua").git_files({ cwd = ByteVim.path.git() })
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fc",
        function()
          require("fzf-lua").files({ cwd = "~/.config/nvim" })
        end,
        desc = "Find Neovim Configs",
      },
      { "<leader>sb", "<cmd>FzfLua grep_curbuf<CR>", desc = "Search Current Buffer" },
      { "<leader>sB", "<cmd>FzfLua lines<CR>", desc = "Search Lines in Open Buffers" },
      {
        "<leader>sw",
        function()
          require("fzf-lua").grep_cword({ cwd = ByteVim.path.git(), multiprocess = true })
        end,
        desc = "Search Word Under Cursor (Git Root)",
      },
      {
        "<leader>sW",
        function()
          require("fzf-lua").grep_cWORD({ cwd = ByteVim.path.git(), multiprocess = true })
        end,
        desc = "Search WORD Under Cursor (Git Root)",
      },
      {
        "<leader>gs",
        function()
          require("fzf-lua").git_status({ cwd = ByteVim.path.git() })
        end,
        desc = "Git Status",
      },
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Git Commits" },
      { "<leader>gb", "<cmd>FzfLua git_branches<CR>", desc = "Git Branches" },
      { "<leader>gB", "<cmd>FzfLua git_bcommits<CR>", desc = "Git Buffer Commits" },
      { "<leader>sa", "<cmd>FzfLua commands<CR>", desc = "Find Actions" },
      { "<leader>s:", "<cmd>FzfLua command_history<CR>", desc = "Find Command History" },
      { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "LSP Document Symbols" },
      { "<leader>sS", "<cmd>FzfLua lsp_workspace_symbols<CR>", desc = "LSP Workspace Symbols" },
      { "<leader>si", "<cmd>FzfLua lsp_incoming_calls<CR>", desc = "LSP Incoming Calls" },
      { "<leader>so", "<cmd>FzfLua lsp_outgoing_calls<CR>", desc = "LSP Outgoing Calls" },
      { "<leader>sk", "<cmd>FzfLua keymaps<CR>", desc = "Search Keymaps" },
      { "<leader>sm", "<cmd>FzfLua marks<CR>", desc = "Search Marks" },
      { "<leader>st", "<cmd>FzfLua tmux_buffers<CR>", desc = "Search Tmux Buffers" },
      { "<leader>sc", "<cmd>FzfLua colorschemes<CR>", desc = "Search Colorschemes" },
      { "<leader>sh", "<cmd>FzfLua help_tags<CR>", desc = "Search Help" },
      { "<leader>sq", "<cmd>FzfLua quickfix<CR>", desc = "Search Quickfix" },
    },
  },

  -- Goto Preview for LSP Navigation
  { "rmagatti/goto-preview", opts = { width = 120, height = 25, default_mappings = true } },

  -- Harpoon for Quick File Navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    keys = {
      {
        "<C-e>",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon Toggle Menu",
      },
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>h",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon Mark 1",
      },
      {
        "<leader>j",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon Mark 2",
      },
      {
        "<leader>k",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon Mark 3",
      },
      {
        "<leader>l",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon Mark 4",
      },
      {
        "<leader><C-p>",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon Next",
      },
      {
        "<leader><C-n>",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon Prev",
      },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },

  -- Illuminate for Highlighting References
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      providers = { "lsp" },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    keys = {
      {
        "]]",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
        desc = "Prev Reference",
      },
    },
  },
  -- Incremental Rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = { { "<leader>rn", "<cmd>IncRename<CR>", desc = "Incremental Rename" } },
  },

  -- Symbols Outline
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

  -- Refactoring Tools
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>rm",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        desc = "Refactoring Menu",
      },
      {
        "<leader>dv",
        function()
          require("refactoring").debug.print_var({ below = true })
        end,
        mode = { "n", "x" },
        desc = "Print Below Variables",
      },
      {
        "<leader>dV",
        function()
          require("refactoring").debug.print_var({ below = false })
        end,
        mode = { "n", "x" },
        desc = "Print Above Variables",
      },
      {
        "<leader>dc",
        function()
          require("refactoring").debug.cleanup({ force = true })
        end,
        desc = "Clear Debugging",
      },
    },
    opts = {},
  },

  -- Tmux Integration
  {
    "nathom/tmux.nvim",
    keys = {
      {
        "<C-h>",
        function()
          require("tmux").move_left()
        end,
        desc = "Go Left Tmux Window",
      },
      {
        "<C-j>",
        function()
          require("tmux").move_down()
        end,
        desc = "Go Top Tmux Window",
      },
      {
        "<C-k>",
        function()
          require("tmux").move_up()
        end,
        desc = "Go Bottom Tmux Window",
      },
      {
        "<C-l>",
        function()
          require("tmux").move_right()
        end,
        desc = "Go Right Tmux Window",
      },
    },
  },

  -- Todo Comments
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    cmd = { "TodoTrouble", "TodoLocList", "TodoQuickFix", "TodoTelescope" },
    keys = { { "<leader>fT", "<cmd>TodoTelescope<cr>", desc = "Todo | Telescope" } },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󰥔 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󱞁 ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
      },
      colors = {
        error = { "DiagnosticError", "#DC2626" },
        warning = { "DiagnosticWarn", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
      search = {
        command = "rg",
        args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
        pattern = [[\b(KEYWORDS):]],
      },
    },
  },

  -- Undo Tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>uT", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree Toggle" } },
    init = function()
      local undodir = vim.fn.expand("~/.undo-nvim")
      if vim.fn.has("persistent_undo") == 1 then
        if vim.fn.isdirectory(undodir) == 0 then
          os.execute("mkdir -p " .. undodir)
        end
        vim.opt.undodir = undodir
        vim.opt.undofile = true
      end
      vim.g.undotree_WindowLayout = 2
    end,
  },

  -- Window Maximizer
  { "szw/vim-maximizer", keys = { { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/Minimize Split" } } },

  -- Zen Mode for Focus
  {
    "folke/zen-mode.nvim",
    keys = {
      {
        "<leader>zz",
        function()
          require("zen-mode").toggle({ window = { width = 90 } })
          vim.wo.wrap = false
          vim.wo.number = true
          vim.wo.rnu = true
        end,
        desc = "Toggle Zen Mode (Normal)",
      },
      {
        "<leader>zZ",
        function()
          require("zen-mode").toggle({ window = { width = 80 } })
          vim.wo.wrap = false
          vim.wo.number = false
          vim.wo.rnu = false
          vim.opt.colorcolumn = "0"
        end,
        desc = "Toggle Zen Mode (Minimal)",
      },
    },
  },

  -- Indent Blankline for Indentation Guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "▏" },
      scope = { show_start = false, show_end = false, show_exact_scope = false },
      exclude = { filetypes = { "help", "startify", "dashboard", "packer", "neogitstatus", "NvimTree", "Trouble" } },
    },
  },

  -- Mini Move for Moving Lines
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {
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
      options = { reindent_linewise = true },
    },
  },

  -- Mini Pairs for Auto Pairs
  {
    "echasnovski/mini.pairs",
    opts = {
      mappings = { ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } } },
    },
    keys = {
      {
        "<leader>up",
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
        end,
        desc = "Toggle Auto Pairs",
      },
    },
  },

  -- Mini Surround for Surround Operations
  { "echasnovski/mini.surround", opts = {} },
}
