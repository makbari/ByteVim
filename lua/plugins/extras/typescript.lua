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
                        preferences = {
                            importModuleSpecifier = "non-relative",
                            jsxAttributeCompletionStyle = "auto",
                        },
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
                        preferences = {
                            importModuleSpecifier = "non-relative",
                            jsxAttributeCompletionStyle = "auto",
                        },
                    },
                },
                on_attach = function(client, bufnr)
                    -- Define buffer-local keymaps for vtsls
                    local function map(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                    end

                    map("<leader>co", ByteVim.lsp.action["source.organizeImports"], "Organize Imports")
                    map("<leader>cM", ByteVim.lsp.action["source.addMissingImports.ts"], "Add missing imports")
                    map("<leader>cu", ByteVim.lsp.action["source.removeUnused.ts"], "Remove unused imports")
                    map("<leader>cD", ByteVim.lsp.action["source.fixAll.ts"], "Fix all diagnostics")
                end,
            },
        },
        inlay_hints = { enabled = false },
        setup = {},
    },
}
