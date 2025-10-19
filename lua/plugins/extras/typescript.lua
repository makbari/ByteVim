return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vtsls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.vtsls = {
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = false },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            preferences = { importModuleSpecifier = "non-relative", jsxAttributeCompletionStyle = "auto" },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            preferences = { importModuleSpecifier = "non-relative", jsxAttributeCompletionStyle = "auto" },
          },
        },
        root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
        single_file_support = false,
        on_attach = function(client, bufnr)
          if ByteVim.lsp.deno_config_exist() then
            client.stop()
          end
          local function map(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
          end
          map("<leader>co", ByteVim.lsp.action["source.organizeImports"], "Organize Imports")
          map("<leader>cM", ByteVim.lsp.action["source.addMissingImports.ts"], "Add missing imports")
          map("<leader>cu", ByteVim.lsp.action["source.removeUnused.ts"], "Remove unused imports")
          map("<leader>cD", ByteVim.lsp.action["source.fixAll.ts"], "Fix all diagnostics")
        end,
      }
    end,
  },
}
