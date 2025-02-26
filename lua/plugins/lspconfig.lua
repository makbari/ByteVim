return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "docker-compose-language-service",
        "json-lsp",
        "stylua",
        "shfmt",
        "pyright",
        "prisma-language-server",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local pkg = mr.get_package(tool)
        if not pkg:is_installed() then
          pkg:install()
        end
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "docker-compose-language-service",
        "json-lsp",
        "stylua",
        "shfmt",
        "pyright",
        "svelte",
        "prisma-language-server",
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
              codeLens = { enable = true },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        pyright = {},
        ruff = {},
        html = { filetypes = { "html", "twig", "hbs" } },
        cssls = {},
        dockerls = {},
        terraformls = {},
        prismals = {},
        jsonls = {},
        yamlls = {},
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
