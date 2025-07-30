return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    servers = {
      vtsls = {
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        settings = {
          typescript = {
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
          local function map(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
          end
          map("<leader>co", function()
            vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
          end, "Organize Imports")
          map("<leader>cM", function()
            vim.lsp.buf.code_action({ context = { only = { "source.addMissingImports.ts" } }, apply = true })
          end, "Add missing imports")
          map("<leader>cu", function()
            vim.lsp.buf.code_action({ context = { only = { "source.removeUnused.ts" } }, apply = true })
          end, "Remove unused imports")
          map("<leader>cD", function()
            vim.lsp.buf.code_action({ context = { only = { "source.fixAll.ts" } }, apply = true })
          end, "Fix all diagnostics")
        end,
      },
    },
    inlay_hints = { enabled = false },
  },
}
