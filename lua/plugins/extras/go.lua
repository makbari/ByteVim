return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "go", "gomod", "gowork" } },
  },

  {
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "delve" } },
  },

  -- Configure gopls with go.nvim for enhanced Go development
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gowork" },
    event = { "CmdlineEnter" },
    build = ':lua require("go.install").update_all_sync()', -- Update tools on plugin install/update
    opts = {
      lsp_cfg = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
        on_attach = function(_, bufnr)
          -- Custom keymaps for Go
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
      lsp_inlay_hints = {
        enable = true,
      },
      gofmt = "gofmt", -- Use gofmt for formatting (integrates with conform.nvim)
      go = "go", -- Use go command
      run_in_floaterm = false, -- Run commands in terminal instead of floaterm
      trouble = false, -- Use native diagnostics instead of Trouble
      luasnip = false, -- No snippets (use your existing setup)
      diagnostic = {
        hdlr = true, -- Hook LSP diagnostics to native Neovim diagnostics
        underline = true,
        virtual_text = true,
        signs = true,
        update_in_insert = false,
      },
    },
    config = function(_, opts)
      require("go").setup(opts)
    end,
  },

  -- Correctly setup lspconfig for Go
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
    },
  },
}
