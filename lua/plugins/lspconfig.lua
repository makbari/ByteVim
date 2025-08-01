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
                "angularls",
                "marksman",
                "cssls",
                "html",
                "prismals",
                "yamlls",
                -- "volar",
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
                prismals = {
                    filetypes = { "prisma" },
                    settings = {
                        prisma = {
                            prismaFmtBinPath = "prisma-fmt", -- Optional: Path to prisma-fmt binary if not in PATH
                        },
                    },
                },
                marksman = {},
                cssls = {},
                html = { filetypes = { "html", "twig", "hbs" } },
                ruby_lsp = {},
                angularls = {
                    filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
                    on_new_config = function(new_config, new_root_dir)
                        new_config.settings = vim.tbl_extend("force", new_config.settings or {}, {
                            angular = {
                                suggest = {
                                    standalone = false,
                                    strictInputTypes = true,
                                },
                            },
                        })
                    end,
                },
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
