return {
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
        ["--layout"] = "reverse",
        ["--info"] = "inline",
        ["--prompt"] = " ",
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
        prompt = " ",
        rg_opts = "--color=never --no-heading --with-filename --line-number --column --smart-case --hidden -g '!{.git,node_modules}'",
      },
      git = {
        files = {
          prompt = " ",
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
            no_ignore = true,
            follow = true,
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
        "<leader>gfs",
        function()
          local root_dir = ByteVim.path.git()
          require("fzf-lua").git_status({ cwd = root_dir })
        end,
        desc = "Git: Status (fzf)",
      },
      { "<leader>gfc", "<cmd> :FzfLua git_commits<CR>", desc = "Git: Commits (fzf)" },
      { "<leader>gfb", "<cmd> :FzfLua git_branches<CR>", desc = "Git: Branches (fzf)" },
      { "<leader>gfB", "<cmd> :FzfLua git_bcommits<CR>", desc = "Git: Buffer commits (fzf)" },
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
        width = 120,
        height = 85,
        default_mappings = true,
        post_open_hook = nil,
        debug = false,
        opacity = 10,
      })
    end,
  },
}
