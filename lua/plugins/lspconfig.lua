return {
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    dependencies = { "mason.nvim" },
    init = function()
      ByteVim.lsp.on_very_lazy(function()
        -- Register the formatter
        ByteVim.format.register({
          name = "none-ls.nvim",
          priority = 200, -- Higher priority for `none-ls.nvim`
          primary = true,
          format = function(buf)
            return ByteVim.lsp.format({
              bufnr = buf,
              filter = function(client)
                return client.name == "null-ls"
              end,
            })
          end,
          sources = function(buf)
            local null_ls_sources = require("null-ls.sources")
            local available_sources = null_ls_sources.get_available(vim.bo[buf].filetype, "NULL_LS_FORMATTING") or {}
            return vim.tbl_map(function(source)
              return source.name
            end, available_sources)
          end,
        })
      end)
    end,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, {
        -- Add your desired formatters and linters here
        nls.builtins.formatting.fish_indent,
        nls.builtins.diagnostics.fish,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.shfmt,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    opts = function()
      local icons = require("config.icons") -- Diagnostics icons
      local lsp_utils = require("utils.lsp") -- LSP helper functions
      local lsp_keymaps = require("utils.lsp-keymaps") -- Custom LSP keymaps

      return {
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
            },
          },
        },
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        format = {
          formatting_options = nil,
          timeout_ms = 3000,
        },
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                workspace = { checkThirdParty = false },
                hint = { enable = true },
              },
            },
          },
          ts_ls = {
            root_dir = function()
              if lsp_utils.deno_config_exist() then
                return nil -- Disable ts_ls if `deno.json` exists
              end
              return vim.fn.getcwd()
            end,
          },
          denols = {
            root_dir = lsp_utils.deno_config_exist,
            settings = { deno = { enable = true } },
          },
          eslint = {
            condition = lsp_utils.eslint_config_exists,
          },
          rust_analyzer = {},
          pyright = {},
        },
        setup = {
          ts_ls = function(_, opts)
            if lsp_utils.deno_config_exist() then
              lsp_utils.stop_lsp_client_by_name("ts_ls")
              return true
            end
            require("lspconfig").ts_ls.setup(opts)
            return true
          end,
          denols = function(_, opts)
            if not lsp_utils.deno_config_exist() then
              lsp_utils.stop_lsp_client_by_name("denols")
              return true
            end
            require("lspconfig").denols.setup(opts)
            return true
          end,
        },
        on_attach = lsp_keymaps.on_attach, -- Attach keymaps on LSP attach
      }
    end,
    config = function(_, opts)
      -- Diagnostics setup
      vim.diagnostic.config(opts.diagnostics)

      -- Add capabilities for autocomplete plugins like nvim-cmp
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )
      opts.capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})

      -- Setup LSP servers dynamically
      local lspconfig = require("lspconfig")
      for server, server_opts in pairs(opts.servers) do
        local merged_opts = vim.tbl_deep_extend("force", { capabilities = opts.capabilities }, server_opts)
        if opts.setup[server] then
          if opts.setup[server](server, merged_opts) then
            goto continue
          end
        end
        lspconfig[server].setup(merged_opts)
        ::continue::
      end
    end,
  },

  -- Mason (Package Manager for LSP Tools)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Open Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua", -- Formatter
        "shfmt", -- Formatter
        "lua-language-server", -- LSP
        "typescript-language-server", -- LSP
        "pyright", -- LSP
        "rust-analyzer", -- LSP
        "deno", -- LSP
      },
    },
    config = function(_, opts)
      require("mason").setup()
      local mason_registry = require("mason-registry")
      mason_registry.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mason_registry.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- Mason-LSPConfig (for Managing LSP Servers)
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls", -- Use the LSP server name here
        "ts_ls", -- LSP for TypeScript
        "pyright", -- LSP for Python
        "rust_analyzer", -- LSP for Rust
        "denols", -- LSP for Deno
        "eslint", -- LSP for JavaScript/TypeScript linting
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },
}
