return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tailwindcss" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
    },
    opts = function(_, opts)
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes_exclude = { "markdown" },
          filetypes_include = {},
          settings = {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          },
        },
      },
      setup = {
        tailwindcss = function(_, opts)
          opts.filetypes = opts.filetypes or {}

          vim.list_extend(opts.filetypes, vim.lsp.config.tailwindcss.filetypes)

          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.tailwindcss = {
        filetypes = { "html", "css", "javascript", "typescript", "htmlangular", "typescriptreact", "typescript.tsx" },
        -- root_dir = require("lspconfig.util").root_pattern("package.json"), -- Keep package.json for general root detection if needed
        settings = {
          tailwindCSS = {
            includeLanguages = {
              html = "html",
              css = "css",
              javascript = "javascript",
              typescript = "typescript",
              htmlangular = "html",
              typescriptreact = "typescriptreact",
              ["typescript.tsx"] = "typescript.tsx",
            },
            experimental = {
              configFile = "src/styles.css", -- Assuming 'src/styles.css' is your main CSS file for v4 config
            },
          },
        },
      }
    end,
  },
}

