return {
  {
    "mistweaverco/kulala.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>Gs", desc = "Send request" },
      { "<leader>Ga", desc = "Send all requests" },
      { "<leader>Gb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = false,
      global_keymaps_prefix = "<leader>G",
      kulala_keymaps_prefix = "",
    },
  },
}
