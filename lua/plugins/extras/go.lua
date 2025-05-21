return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "go", "gomod", "gowork" },
  event = { "CmdlineEnter" },
  build = ':lua require("go.install").update_all_sync()',
  opts = {
    lsp_cfg = {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      on_attach = function(_, bufnr)
        local function map(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, silent = true, desc = desc })
        end
        map("n", "<leader>cG", "<cmd>GoCodeAction<cr>", "Go Code Action")
        map("n", "<leader>gt", "<cmd>GoTest<cr>", "Run Go Tests")
        map("n", "<leader>gr", "<cmd>GoRun<cr>", "Run Go Program")
        map("n", "<leader>gb", "<cmd>GoBuild<cr>", "Build Go Program")
        map("n", "<leader>gd", "<cmd>GoDebug<cr>", "Start Go Debug (Delve)")
      end,
    },
    lsp_inlay_hints = { enable = true },
    gofmt = "gofmt",
    go = "go",
    run_in_floaterm = false,
    trouble = false,
    luasnip = false,
    diagnostic = {
      hdlr = true,
      underline = true,
      virtual_text = true,
      signs = true,
      update_in_insert = false,
    },
  },
  config = function(_, opts)
    require("go").setup(opts)
  end,
}
