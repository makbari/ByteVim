return {
    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
          -- Set an empty statusline until lualine loads
          vim.o.statusline = " "
        else
          -- Hide the statusline on the starter page
          vim.o.laststatus = 0
        end
      end,
      opts = function()
        local icons = require("config.icons") -- Use your custom icons
        vim.o.laststatus = vim.g.lualine_laststatus
        return {
          options = {
            theme = "auto",
            globalstatus = vim.o.laststatus == 3,
            disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = {
              {
                "diagnostics",
                symbols = {
                  error = icons.diagnostics.Error,
                  warn = icons.diagnostics.Warn,
                  info = icons.diagnostics.Info,
                  hint = icons.diagnostics.Hint,
                },
              },
              { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
              { "filename", path = 1 }, -- Show the file path
            },
            lualine_x = {
              {
                "diff",
                symbols = {
                  added = icons.git.LineAdded,
                  modified = icons.git.LineModified,
                  removed = icons.git.LineRemoved,
                },
              },
              { "encoding" },
              { "fileformat" },
          { "filetype" },
            },
            lualine_y = { "progress" },
            lualine_z = { { function() return " " .. os.date("%R") end } },
          },
          extensions = { "neo-tree", "lazy" },
        }
      end,
    },
    -- Icons
    {
      "echasnovski/mini.icons",
      lazy = true,
      opts = {
        file = {
          [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
          ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        },
        filetype = {
          dotenv = { glyph = "", hl = "MiniIconsYellow" },
        },
      },
      init = function()
        package.preload["nvim-web-devicons"] = function()
          require("mini.icons").mock_nvim_web_devicons()
          return package.loaded["nvim-web-devicons"]
        end
      end,
    },
    -- Dashboard with snacks
    {
      "folke/snacks.nvim",
      opts = {
        dashboard = {
          preset = {
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
              { icon = " ", key = "c", desc = "Config", action = ":edit $MYVIMRC" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
        },
      },
    },
  }
  