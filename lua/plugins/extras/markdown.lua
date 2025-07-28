return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                marksman = {},
            },
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    -- Markdown preview
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {},
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = {
            linters_by_ft = {
                markdown = { "markdownlint" },
            },
        },
    },
    {
        "lukas-reineke/headlines.nvim",
        enabled = false,
        opts = function()
            local opts = {}
            for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
                opts[ft] = { headline_highlights = {} }
                for i = 1, 6 do
                    table.insert(opts[ft].headline_highlights, "Headline" .. i)
                end
            end
            return opts
        end,
        ft = { "markdown", "norg", "rmd", "org" },
        config = function(_, opts)
            vim.schedule(function()
                local hl = require("headlines")
                hl.setup(opts)
                local md = hl.config.markdown
                hl.refresh()
                vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
                    callback = function(data)
                        if vim.bo.filetype == "markdown" then
                            hl.config.markdown = data.event == "InsertLeave" and md or nil
                            hl.refresh()
                        end
                    end,
                })
            end)
        end,
    },
}

