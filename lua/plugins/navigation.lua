return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
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
          require("harpoon"):list():add()
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>h",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon: Mark 1",
      },
      {
        "<leader>j",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon: Mark 2",
      },
      {
        "<leader>k",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon: Mark 3",
      },
      {
        "<leader>l",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon: Mark 4",
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
    config = function(_, options)
      local status_ok, harpoon = pcall(require, "harpoon")
      if not status_ok then
        return
      end

      harpoon:setup(options)

      vim.keymap.set("n", "<leader>fm", function()
        local list = harpoon:list()
        local files = {}
        for _, item in ipairs(list.items) do
          table.insert(files, item.value)
        end
        if #files == 0 then
          vim.notify("No mark found", vim.log.levels.INFO, { title = "Harpoon" })
          return
        end
        require("fzf-lua").fzf_exec(files, {
          prompt = "Harpoon❯ ",
          actions = {
            ["default"] = function(selected)
              if selected[1] then
                vim.cmd("edit " .. vim.fn.fnameescape(selected[1]))
              end
            end,
          },
          previewer = "builtin",
        })
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
    "nathom/tmux.nvim",
    config = function()
      local map = vim.api.nvim_set_keymap
      map("n", "<C-h>", [[<cmd>lua require('tmux').move_left()<cr>]], { desc = "Go left tmux window" })
      map("n", "<C-j>", [[<cmd>lua require('tmux').move_down()<cr>]], { desc = "Go top tmux window" })
      map("n", "<C-k>", [[<cmd>lua require('tmux').move_up()<cr>]], { desc = "Go bottom tmux window" })
      map("n", "<C-l>", [[<cmd>lua require('tmux').move_right()<cr>]], { desc = "Go right tmux window" })
    end,
  },
}
