local Path = require("utils.path")

-- Find all files, including hidden ones
local function find_all_files()
  require("telescope.builtin").find_files({
    follow = true,
    no_ignore = true,
    hidden = true,
  })
end

-- Find files from the project's Git root
local function find_files_from_project_git_root()
  local opts = {}
  if Path.is_git_repo() then
    opts = {
      cwd = Path.get_git_root(),
    }
  end
  require("telescope.builtin").find_files(opts)
end

-- Live grep from the project's Git root
local function live_grep_from_project_git_root()
  local opts = {}
  if Path.is_git_repo() then
    opts = {
      cwd = Path.get_git_root(),
    }
  end
  require("telescope.builtin").live_grep(opts)
end

-- Fuzzy find within the current buffer
local function fuzzy_find_in_current_buffer()
  require("telescope.builtin").current_buffer_fuzzy_find()
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      defaults = {
        prompt_prefix = "   ",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "bottom",
            preview_width = 0.55,
            results_width = 0.8,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        path_display = { "truncate" },
      },
    },
    keys = {
      { "<leader>fa", find_all_files, desc = "Find All Files (including hidden)" },
      { "<leader>fl", live_grep_from_project_git_root, desc = "Live Grep From Project Git Root" },
      { "<leader>fg", find_files_from_project_git_root, desc = "Find Files From Project Git Root" },
      { "<leader>fb", fuzzy_find_in_current_buffer, desc = "Fuzzy Find in Current Buffer" },
    },
  },
}
