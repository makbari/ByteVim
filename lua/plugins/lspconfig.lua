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
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
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
        ts_ls = {},
        denols = {},
        html = { filetypes = { "html", "twig", "hbs" } },
        cssls = {},
        dockerls = {},
        terraformls = {},
        jsonls = {},
        yamlls = {},
      },
      inlay_hints = { enabled = true },
      setup = {},
    },
    config = function(_, opts)
      ByteVim.lsp.setup(opts)
    end,
  },
  -- {
  --   'neovim/nvim-lspconfig',
  --   dependencies = {
  --     -- Automatically install LSPs and related tools to stdpath for Neovim
  --     { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
  --     'williamboman/mason-lspconfig.nvim',
  --     'WhoIsSethDaniel/mason-tool-installer.nvim',

  --     -- Useful status updates for LSP.
  --     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
  --     { 'j-hui/fidget.nvim', opts = {} },

  --     -- Allows extra capabilities provided by nvim-cmp
  --     'hrsh7th/cmp-nvim-lsp',
  --   },
  --   opts = {
  --     servers = {
  --       lua_ls = {
  --         settings = {
  --           Lua = {
  --             workspace = { checkThirdParty = false },
  --             codeLens = { enable = true },
  --             completion = { callSnippet = "Replace" },
  --           },
  --         },
  --       },
  --       pyright = {},
  --       ts_ls = {},
  --     },
  --     inlay_hints = { enabled = true },
  --     setup = {},
  --   },
  --   config = function(_, opts)
  --     local nvim_lsp = require("lspconfig")
  --     local capabilities = vim.lsp.protocol.make_client_capabilities()

  --     -- Diagnostic symbols in the sign column (gutter)
  --     for type, icon in pairs({ Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }) do
  --       vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
  --     end

  --     -- Setting up Mason and LSP with proper handler setup
  --     local mason_lspconfig = require("mason-lspconfig")
  --     mason_lspconfig.setup({
  --       ensure_installed = vim.tbl_keys(opts.servers),
  --     })
  --     local function setup_ts_or_deno()
  --       local server_opts = { capabilities = capabilities }

  --       if ByteVim.lsp.deno_config_exist() then
  --         -- Configure for Deno if it's a Deno project
  --         nvim_lsp.denols.setup(server_opts)
  --       elseif ByteVim.lsp.get_config_path("package.json") then
  --         -- Configure for TypeScript if it's a TypeScript project
  --         nvim_lsp.ts_ls.setup(vim.tbl_deep_extend("force", server_opts, {
  --           settings = {
  --             code_lens = "off",
  --             tsserver_file_preferences = {
  --               includeInlayParameterNameHints = "literals",
  --               includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --               includeInlayFunctionParameterTypeHints = false,
  --               includeInlayVariableTypeHints = false,
  --               includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  --               includeInlayPropertyDeclarationTypeHints = false,
  --               includeInlayFunctionLikeReturnTypeHints = true,
  --               includeInlayEnumMemberValueHints = true,
  --             },
  --           },
  --         }))
  --       end
  --     end

  --     -- Setup handlers for all servers, including custom setup for ts_ls and denols
  --     mason_lspconfig.setup_handlers({
  --       function(server)
  --         if server == "ts_ls" or server == "denols" then
  --           setup_ts_or_deno()
  --         else
  --           local server_opts =
  --             vim.tbl_deep_extend("force", { capabilities = capabilities }, opts.servers[server] or {})
  --           if server.enabled then
  --             nvim_lsp[server].setup(server_opts)
  --           end
  --         end
  --       end,
  --     })

  --     -- LSP Keymaps
  --     vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  --     vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
  --     vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
  --     vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "List references" })
  --     vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
  --     vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation" })
  --     vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "Show signature help" })
  --     vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
  --     vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
  --     vim.keymap.set("n", "<leader>ed", vim.diagnostic.open_float, { desc = "Open diagnostics" })
  --     vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
  --     vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  --     vim.keymap.set("n", "<leader>ih", function()
  --       vim.lsp.inlay_hint(0, nil)
  --     end, { desc = "Toggle inlay hints" })
  --   end,
  -- },
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
    "lvimuser/lsp-inlayhints.nvim",
    ft = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescriptreact", "svelte", "go", "rust" },
    opts = {
      debug_mode = true,
    },
    config = function(_, options)
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- Check if this is a Deno or TypeScript project before attaching inlay hints
          local is_deno_project = ByteVim.lsp.deno_config_exist()
          local is_ts_project = ByteVim.lsp.get_config_path("package.json") ~= nil

          if client.name == "denols" and is_deno_project then
            require("lsp-inlayhints").on_attach(client, bufnr)
          elseif client.name == "ts_ls" and is_ts_project then
            require("lsp-inlayhints").on_attach(client, bufnr)
          end
        end,
      })

      require("lsp-inlayhints").setup(options)

      -- Keymap to toggle inlay hints
      vim.api.nvim_set_keymap(
        "n",
        "<leader>uh",
        "<cmd>lua require('lsp-inlayhints').toggle()<CR>",
        { noremap = true, silent = true, desc = "Toggle Inlay Hints" }
      )
    end,
  },
  {
    "Wansmer/symbol-usage.nvim",
    opts = {
      vt_position = "end_of_line",
      text_format = function(symbol)
        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          return string.format(" 󰌹 %s %s", num, usage)
        else
          return ""
        end
      end,
    },
  },
}
