return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "jsonls",
        "marksman",
        "cssls",
        "html",
        "prismals",
        "vue-language-server",
        "gopls",
      },
    },
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        pyright = {},
        jsonls = {},
        prismals = {},
        marksman = {},
        cssls = {},
        html = { filetypes = { "html", "twig", "hbs" } },
      },
      inlay_hints = { enabled = true },
      setup = {},
    },
    config = function(_, opts)
      ByteVim.lsp.setup(opts)
      ByteVim.lsp_keymaps.setup_keymaps()
    end,
  },
}
