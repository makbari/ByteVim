return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
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
        "volar",
        "gopls",
      },
    },
    handlers = {}, -- Disable automatic setup by setting handlers to an empty table
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      dependencies = {
        "mason.nvim",
        { "mason-org/mason-lspconfig.nvim", config = function() end },
      },
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
      local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
      ByteVim.lsp.disable("vtsls", is_deno)
      ByteVim.lsp.disable("denols", function(root_dir, config)
        if not is_deno(root_dir) then
          config.settings.deno.enable = false
        end
        return false
      end)
    end,
  },
}

