return {
  -- {
  --   "MunifTanjim/nui.nvim",
  --   lazy = true,
  -- },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    event = "bufenter",
    keys = {
      { "<leader>er", ":Neotree reveal float<CR>", silent = true, desc = "Reveal Float File Explorer" },
      { "<leader><Tab>", ":Neotree toggle left<CR>", silent = true, desc = "Left File Explorer" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "single",
        enable_git_status = true,
        enable_modified_markers = true,
        enable_diagnostics = true,
        sort_case_insensitive = true,
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
        window = {
          position = "float",
          width = 35,
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          bind_to_cw = false,
          use_lsp_handlers = true,
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
        -- source_selector = {
        --   winbar = true,
        --   sources = {
        --     { source = "filesystem", display_name = "   Files " },
        --     { source = "buffers", display_name = "   Bufs " },
        --     { source = "git_status", display_name = "   Git " },
        --   },
        -- },
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
      })
    end,
  },
  -- search/replace in multiple files
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
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "f-person/git-blame.nvim",
    init = function()
      vim.keymap.set(
        "n",
        "<leader>gB",
        "<cmd>GitBlameOpenCommitURL<cr>",
        { desc = "GitBlame | Open Commit Url", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>gc",
        "<cmd>GitBlameCopyCommitURL<cr>",
        { desc = "GitBlame | Copy Commit Url", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>gf",
        "<cmd>GitBlameOpenFileURL<cr>",
        { desc = "GitBlame | Open File Url", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>gC",
        "<cmd>GitBlameCopyFileURL<cr>",
        { desc = "GitBlame | Copy File Url", silent = true }
      )
      vim.keymap.set("n", "<leader>gs", "<cmd>GitBlameCopySHA<cr>", { desc = "GitBlame | Copy SHA", silent = true })
      vim.keymap.set("n", "<leader>gt", "<cmd>GitBlameToggle<cr>", { desc = "GitBlame | Toggle Blame", silent = true })
    end,
    cmd = {
      "GitBlameToggle",
      "GitBlameEnable",
      "GitBlameOpenCommitURL",
      "GitBlameCopyCommitURL",
      "GitBlameOpenFileURL",
      "GitBlameCopyFileURL",
      "GitBlameCopySHA",
    },
    opts = {},
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = true,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons", "neovim/nvim-lspconfig" },
    opts = {
      hls = {
        border = "FloatBorder",
        cursorline = "Visual",
        cursorlinenr = "Visual",
      },
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
        ["--border"] = false,
        ["--preview-window"] = false,
        ["--layout"] = "reverse", -- prompt at top
        ["--info"] = "inline", -- similar to prompt_position top
        ["--prompt"] = " ", -- custom prompt
      },
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.5,
        col = 0.5,
        preview = {
          layout = "vertical",
          vertical = "up:65%",
        },
      },
      files = {
        multiprocess = true,
        git_icons = false,
        file_icons = false,
      },
      grep = {
        prompt = " ",
        rg_opts = "--color=never --no-heading --with-filename --line-number --column --smart-case --hidden -g '!{.git,node_modules}'",
      },
      git = {
        files = {
          prompt = " ",
          cmd = "git ls-files --recurse-submodules --exclude-standard --others --cached",
          multiprocess = true,
        },
        status = {
          winopts = {
            preview = { vertical = "down:70%", horizontal = "right:70%" },
          },
        },
        commits = { winopts = { preview = { vertical = "down:60%" } } },
        bcommits = { winopts = { preview = { vertical = "down:60%" } } },
        branches = {
          winopts = {
            preview = { vertical = "down:75%", horizontal = "right:75%" },
          },
        },
      },
      lsp = {
        async_or_timeout = true,
        symbols = {
          path_shorten = 1,
        },
        code_actions = {
          winopts = {
            preview = { layout = "reverse-list", horizontal = "right:75%" },
          },
        },
      },
    },
    config = function(_, options)
      local fzf_lua = require("fzf-lua")
      fzf_lua.setup(options)
      fzf_lua.register_ui_select(function(_, items)
        local min_h, max_h = 0.60, 0.80
        local h = (#items + 4) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.80, row = 0.40 } }
      end)
    end,
    keys = {
      { "<C-g>", "<cmd> :FzfLua grep_project<CR>", desc = "Find Grep" },
      {
        "<C-g>",
        function()
          local fzf_lua = require("fzf-lua")
          fzf_lua.setup({
            grep = {
              actions = { ["ctrl-r"] = { fzf_lua.actions.toggle_ignore } },
            },
          })
        end,
        desc = "Search Grep in visual selection",
        mode = "v",
      },
      {
        "<leader>fi",
        function()
          local root_dir = ByteVim.path.root()
          require("fzf-lua").files({
            cwd = root_dir,
            multiprocess = true,
            git_icons = true,
            file_icons = true,
            hidden = true,
            no_ignore = true,
            no_ignore_parent = true,
            no_ignore_vcs = true,
            prompt = "AllFiles❯ ",
          })
        end,
        desc = "Find All Files (including gitignored)",
      },
      {
        "<leader>fI",
        function()
          local root_dir = ByteVim.path.root()
          require("fzf-lua").live_grep({
            cwd = root_dir,
            multiprocess = true,
            no_ignore = true,
            no_ignore_parent = true,
            no_ignore_vcs = true,
            prompt = "GrepAll❯ ",
          })
        end,
        desc = "Grep All Files (including gitignored)",
      },
      {
        "<leader>fr",
        function()
          local root_dir = ByteVim.path.git()
          require("fzf-lua").oldfiles({ cwd = root_dir })
        end,
        desc = "Find Recent Files",
      },
      {
        "<leader>/",
        function()
          local root_dir = ByteVim.path.root()
          require("fzf-lua").live_grep({ cwd = root_dir, multiprocess = true })
        end,
        desc = "Grep Files at current directory",
      },
      {
        "<leader>fa",
        function()
          local root_dir = ByteVim.path.git()
          require("fzf-lua").grep({
            cwd = root_dir,
            cmd = "git grep --line-number --color=always ''",
          })
        end,
        desc = "Search in Git-tracked Files (git grep)",
      },
      {
        "<leader>F",
        function()
          local root_dir = ByteVim.path.root()
          require("fzf-lua").files({
            cwd = root_dir,
            multiprocess = true,
            git_icons = true,
            file_icons = true,
            hidden = true,
            no_ignore = true, -- include .gitignored files
            follow = true, -- follow symlinks
          })
        end,
        desc = "Find All Files",
      },
      {
        "<leader>ff",
        function()
          local root_dir = ByteVim.path.git()
          require("fzf-lua").files({ cwd = root_dir, multiprocess = true })
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
      { "<leader>sb", "<cmd> :FzfLua grep_curbuf<CR>", desc = "Search Current Buffer" },
      { "<leader>sB", "<cmd> :FzfLua lines<CR>", desc = "Search Lines in Open Buffers" },
      {
        "<leader>sw",
        function()
          local root_dir = ByteVim.path.git()
          require("fzf-lua").grep_cword({ cwd = root_dir, multiprocess = true })
        end,
        desc = "Search word under cursor (git root)",
      },
      {
        "<leader>sW",
        function()
          local root_dir = ByteVim.path.git()
          require("fzf-lua").grep_cWORD({ cwd = root_dir, multiprocess = true })
        end,
        desc = "Search WORD under cursor (git root)",
      },
      {
        "<leader>gs",
        function()
          local root_dir = ByteVim.path.git()
          require("fzf-lua").git_status({ cwd = root_dir })
        end,
        desc = "Git Status",
      },
      { "<leader>gc", "<cmd> :FzfLua git_commits<CR>", desc = "Git Commits" },
      { "<leader>gb", "<cmd> :FzfLua git_branches<CR>", desc = "Git Branches" },
      { "<leader>gB", "<cmd> :FzfLua git_bcommits<CR>", desc = "Git Buffer Commits" },
      { "<leader>sa", "<cmd> :FzfLua commands<CR>", desc = "Find Actions" },
      { ">leader>s:", "<cmd> :FzfLua command_history<CR>", desc = "Find Command History" },
      { "<leader>ss", "<cmd> :FzfLua lsp_document_symbols<CR>", desc = "LSP Document Symbols" },
      { "<leader>sS", "<cmd> :FzfLua lsp_workspace_symbols<CR>", desc = "LSP Workspace Symbols" },
      { "<leader>si", "<cmd> :FzfLua lsp_incoming_calls<CR>", desc = "LSP Incoming Calls" },
      { "<leader>so", "<cmd> :FzfLua lsp_outgoing_calls<CR>", desc = "LSP Outgoing Calls" },
      { "<leader>sk", "<cmd> :FzfLua keymaps<CR>", desc = "Search Keymaps" },
      { "<leader>sm", "<cmd> :FzfLua marks<CR>", desc = "Search Marks" },
      { "<leader>st", "<cmd> :FzfLua tmux_buffers<CR>", desc = "Search Tmux buffers" },
      { "<leader>sc", "<cmd> :FzfLua colorschemes<CR>", desc = "Search colorschemes" },
      { "<leader>sh", "<cmd> :FzfLua help_tags<CR>", desc = "Search Help" },
      { "<leader>sq", "<cmd> :FzfLua quickfix<CR>", desc = "Search Quickfix" },
    },
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup({
        width = 120, -- Width of the floating window
        height = 85, -- Height of the floating window
        default_mappings = true, -- Enable/disable default key mappings
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        debug = false, -- Print debug information
        opacity = 10, -- Set opacity to 80%More actions
      })
    end,
  },
  { "nvim-telescope/telescope-ui-select.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
  },
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --     { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  --   },
  --   cmd = "Telescope",
  --   keys = {
  --     { "<C-g>", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
  --     {
  --       "<C-g>",
  --       function()
  --         require("telescope.builtin").live_grep({ default_text = vim.fn.getreg('"') })
  --       end,
  --       mode = "v",
  --       desc = "Grep Visual Selection",
  --     },
  --     {
  --       "<leader>sw",
  --       function()
  --         require("telescope.builtin").live_grep({
  --           default_text = vim.fn.getreg('"'),
  --           cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
  --         })
  --       end,
  --       mode = "v",
  --       desc = "Grep Visual Selection (Git Root)",
  --     },
  --     {
  --       "<leader>fr",
  --       function()
  --         require("telescope.builtin").oldfiles({
  --           cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
  --         })
  --       end,
  --       desc = "Find Recent Files",
  --     },
  --     {
  --       "<leader>/",
  --       function()
  --         require("telescope.builtin").live_grep()
  --       end,
  --       desc = "Grep Files at Current Directory",
  --     },
  --     {
  --       "<leader>ff",
  --       function()
  --         require("telescope.builtin").git_files({
  --           cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
  --         })
  --       end,
  --       desc = "Find Git Files",
  --     },
  --     {
  --       "<leader>fc",
  --       function()
  --         require("telescope.builtin").find_files({ cwd = "~/.config/nvim" })
  --       end,
  --       desc = "Find Neovim Configs",
  --     },
  --     { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search Current Buffer" },
  --     { "<leader>sB", "<cmd>Telescope buffers<CR>", desc = "Search Open Buffers" },
  --     {
  --       "<leader>sw",
  --       function()
  --         require("telescope.builtin").grep_string({
  --           cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
  --         })
  --       end,
  --       desc = "Search Word Under Cursor (Git Root)",
  --     },
  --     {
  --       "<leader>sW",
  --       function()
  --         require("telescope.builtin").grep_string({
  --           cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
  --           word_match = "-w",
  --         })
  --       end,
  --       desc = "Search WORD Under Cursor (Git Root)",
  --     },
  --     {
  --       "<leader>gs",
  --       function()
  --         require("telescope.builtin").git_status({
  --           cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
  --         })
  --       end,
  --       desc = "Git Status",
  --     },
  --     { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
  --     { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git Branches" },
  --     { "<leader>gB", "<cmd>Telescope git_bcommits<CR>", desc = "Git Buffer Commits" },
  --     { "<leader>sa", "<cmd>Telescope commands<CR>", desc = "Find Actions" },
  --     { "<leader>s:", "<cmd>Telescope command_history<CR>", desc = "Find Command History" },
  --     { "<leader>ss", "<cmd>Telescope lsp_document_symbols<CR>", desc = "LSP Document Symbols" },
  --     { "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "LSP Workspace Symbols" },
  --     { "<leader>si", "<cmd>Telescope lsp_incoming_calls<CR>", desc = "LSP Incoming Calls" },
  --     { "<leader>so", "<cmd>Telescope lsp_outgoing_calls<CR>", desc = "LSP Outgoing Calls" },
  --     { "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Search Keymaps" },
  --     { "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Search Marks" },
  --     { "<leader>sc", "<cmd>Telescope colorscheme<CR>", desc = "Search Colorschemes" },
  --     { "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Search Help" },
  --     { "<leader>sq", "<cmd>Telescope quickfix<CR>", desc = "Search Quickfix" },
  --   },
  --   opts = {
  --     defaults = {
  --       vimgrep_arguments = {
  --         "rg",
  --         "--color=never",
  --         "--no-heading",
  --         "--with-filename",
  --         "--line-number",
  --         "--column",
  --         "--smart-case",
  --         "--hidden",
  --         "--glob",
  --         "!{.git,node_modules}",
  --       },
  --       prompt_prefix = " ",
  --       selection_caret = "➜ ",
  --       layout_strategy = "horizontal",
  --       layout_config = {
  --         height = 0.85,
  --         width = 0.80,
  --         prompt_position = "top",
  --         preview_cutoff = 120,
  --       },
  --       sorting_strategy = "ascending",
  --       file_ignore_patterns = { ".git/", "node_modules/" },
  --     },
  --     pickers = {
  --       find_files = {
  --         hidden = true,
  --         no_ignore = false,
  --       },
  --       live_grep = {
  --         additional_args = { "--hidden" },
  --       },
  --       git_files = {
  --         show_untracked = true,
  --       },
  --     },
  --     extensions = {
  --       fzf = {
  --         fuzzy = true,
  --         override_generic_sorter = true,
  --         override_file_sorter = true,
  --         case_mode = "smart_case",
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     local telescope = require("telescope")
  --     telescope.setup(opts)
  --     telescope.load_extension("fzf")
  --     telescope.load_extension("ui-select")
  --   end,
  -- },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- event = "VeryLazy",
    lazy = false,

    keys = {
      {
        "<C-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon toggle menu",
      },
      {
        "<leader>a",
        function()
          local harpoon = require("harpoon")
          harpoon:list():add()
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>h",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(1)
        end,
        desc = "Harpoon: Mark 1",
      },
      {
        "<leader>j",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(2)
        end,
        desc = "Harpoon: Mark 2",
      },
      {
        "<leader>k",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(3)
        end,
        desc = "Harpoon: Mark 3",
      },
      {
        "<leader>l",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(4)
        end,
        desc = "Harpoon: Mark 4",
      },
      {
        "<leader><C-p>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():next()
        end,
        desc = "Harpoon Next",
      },
      {
        "<leader><C-n>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():prev()
        end,
        desc = "Harpoon Prev",
      },
    },
    config = function(_, options)
      local status_ok, harpoon = pcall(require, "harpoon")
      if not status_ok then
        return
      end

      -- REQUIRED
      harpoon:setup(options)
      -- REQUIRED
      local tele_status_ok, _ = pcall(require, "telescope")
      if not tele_status_ok then
        return
      end

      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        if #file_paths == 0 then
          vim.notify("No mark found", vim.log.levels.INFO, { title = "Harpoon" })
          return
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      vim.keymap.set("n", "<leader>fm", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
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
      keymaps = { -- These keymaps can be a string or a table for multiple keys
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
      -- Debug variable
      {
        "<leader>dv",
        function()
          require("refactoring").debug.print_var({
            below = true,
          })
        end,
        mode = { "n", "x" },
        desc = "Print below variables",
      },
      {
        "<leader>dV",
        function()
          require("refactoring").debug.print_var({
            below = false,
          })
        end,
        mode = { "n", "x" },
        desc = "Print above variables",
      },
      -- Clean up debugging
      {
        "<leader>dc",
        function()
          require("refactoring").debug.cleanup({
            force = true,
          })
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

      local tele_status_ok, telescope = pcall(require, "telescope")
      if not tele_status_ok then
        return
      end

      telescope.load_extension("refactoring")
    end,
  },
  {
    "nathom/tmux.nvim",
    config = function()
      local map = vim.api.nvim_set_keymap
      map("n", "<C-h>", [[<cmd>lua require('tmux').move_left()<cr>]], { desc = "Go left tmux window" })
      map("n", "<C-j>", [[<cmd>lua require('tmux').move_down()<cr>]], { desc = "Go top tmux window" })
      map("n", "<C-k>", [[<cmd>lua require('tmux').move_up()<cr>]], { desc = "Go bottom tmux window" })
      map("n", "<C-l>", [[<cmd>lua require('tmux').move_right()<cr>]], { desc = "Go right tmux window" })
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    cmd = { "TodoTrouble", "TodoLocList", "TodoQuickFix", "TodoTelescope" },
    init = function()
      vim.keymap.set("n", "<leader>fT", "<cmd>TodoTelescope<cr>", { desc = "Todo | Telescope", silent = true })
    end,
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󰥔 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󱞁 ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uT", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree Toggle" },
    },
    init = function()
      -- Persist undo, refer https://github.com/mbbill/undotree#usage
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
  {
    "folke/zen-mode.nvim",
    config = function()
      vim.keymap.set("n", "<leader>zz", function()
        require("zen-mode").setup({
          window = {
            width = 140,
            options = {},
          },
        })
        require("zen-mode").toggle()
        vim.wo.wrap = false
        vim.wo.number = true
        vim.wo.rnu = true
      end)
      vim.keymap.set("n", "<leader>zZ", function()
        require("zen-mode").setup({
          window = {
            width = 80,
            options = {},
          },
        })
        require("zen-mode").toggle()
        vim.wo.wrap = false
        vim.wo.number = false
        vim.wo.rnu = false
        vim.opt.colorcolumn = "0"
      end)
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
      },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = false,
      },
      exclude = {
        filetypes = {
          "help",
          "startify",
          "dashboard",
          "packer",
          "neogitstatus",
          "NvimTree",
          "Trouble",
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter", -- Required for treesitter provider
    },
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function(_, filetype, _)
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
  {
    "mistweaverco/bafa.nvim",
    version = "v1.10.1",
  },
}
