return {
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "stylua", "jq", "black" },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {
      ensure_installed = { "delve", "codelldb" },
    },
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "pyright", -- Python LSP server
        "lua_ls", -- Lua LSP server,
        "prismals",
        "gopls",
        "ts_ls",
        "denols"
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      local servers = {}
      local extras_path = vim.fn.stdpath("config") .. "/lua/plugins/extras"
      local extras_files = vim.fn.globpath(extras_path, "*.lua", false, true)
      for _, file in ipairs(extras_files) do
        local basename = vim.fn.fnamemodify(file, ":t:r") -- Get filename without extension
        local config = require("plugins.extras." .. basename)
        servers = vim.tbl_extend("force", servers, config)
      end
      return {
        servers = servers,
        inlay_hints = { enabled = true },
        setup = {
          ts_ls = function(_, opts)
            if ByteVim.lsp.deno_config_exist() or not ByteVim.lsp.node_config_exist() then
              return true 
            end
            require("lspconfig").ts_ls.setup(opts)
            ByteVim.lsp.stop_lsp_client_by_name("denols")
          end,
          denols = function(_, opts)
            if not ByteVim.lsp.deno_config_exist() then
              return true
            end
            require("lspconfig").denols.setup(opts)
            ByteVim.lsp.stop_lsp_client_by_name("ts_ls")
          end,
        },
      }
    end,
    config = function(_, opts)
      vim.filetype.add({
        extension = {
          prisma = "prisma",
          ts = "typescript",
          tsx = "typescriptreact",
          js = "javascript",
          jsx = "javascriptreact",
        },
      })
      require("utils.lsp").setup(opts)
      require("utils.lsp_keymaps").setup_keymaps()
    end,
  },
}

