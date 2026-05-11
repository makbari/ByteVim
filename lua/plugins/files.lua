return {
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
            symbol = " ",
            highlight = "NeoTreeModified",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            folder_empty_open = "",
          },
          git_status = {
            symbols = {
              added = "",
              deleted = "",
              modified = "",
              renamed = "",
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = "",
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
            never_show = {
              ".DS_Store",
              "thumbs.db",
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
      })
    end,
  },
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
}
