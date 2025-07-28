return {
  -- commented out because of start time is too long with this plugin
  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000,
  --   name = "tokyonight",
  --   opts = {
  --     style = "moon",
  --   },
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "ntk148v/komau.vim",
    priority = 1000,
    name = "komau",
    config = function()
      -- Optional: set your favorite variant
      vim.g.komau_variant = "mocha" -- "dark", "darker", "midnight", "mocha", "aura"
    end,
  },
  { "EdenEast/nightfox.nvim" }, -- lazy,
  {
    "shaunsingh/nord.nvim",
    lazy = false, -- load on startup
    priority = 1000, -- load before other UI plugins
    config = function()
      -- Optional: override some Nord settings before loading
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false -- set true if using transparency
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true
    end,
  },
}
