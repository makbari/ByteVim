-- ~/nvim/lua/utils/lsp.lua (Corrected)

local Path = require("utils.path")

local M = {}

function M.get_config_path(filename)
    local current_dir = vim.fn.getcwd()
    local config_file = current_dir .. "/" .. filename
    if vim.fn.filereadable(config_file) == 1 then
        return current_dir
    end

    local git_root = Path.get_git_root()
    if Path.is_git_repo() and git_root ~= current_dir then
        config_file = git_root .. "/" .. filename
        if vim.fn.filereadable(config_file) == 1 then
            return git_root
        end
    end

    return nil
end

function M.stop_lsp_client_by_name(name)
    for _, client in ipairs(vim.lsp.get_active_clients()) do
        if client.name == name then
            vim.lsp.stop_client(client.id, true)
            return
        end
    end
end

function M.deno_config_exist()
    return M.get_config_path("deno.json") ~= nil or M.get_config_path("deno.jsonc") ~= nil
end

function M.eslint_config_exists()
    local config_files = {
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
        ".eslintrc",
    }

    local check_paths = { vim.fn.getcwd() }
    local git_root = Path.get_git_root()
    if Path.is_git_repo() and git_root ~= vim.fn.getcwd() then
        table.insert(check_paths, git_root)
    end

    for _, dir in ipairs(check_paths) do
        for _, file in ipairs(config_files) do
            if vim.fn.filereadable(dir .. "/" .. file) == 1 then
                return true
            end
        end
    end
    return false
end

function M.on_attach(on_attach_fn)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
                on_attach_fn(client, buffer)
            end
        end,
    })
end

function M.is_enabled(server)
    local c = M.get_config(server)
    return c and c.enabled ~= false
end

function M.get_config(server)
    local configs = require("lspconfig.configs")
    return rawget(configs, server)
end

function M.disable(server, cond)
    local util = require("lspconfig.util")
    local def = M.get_config(server)
    if def ~= nil then
        def.document_config.on_new_config = util.add_hook_before(
            def.document_config.on_new_config,
            function(config, root_dir)
                if cond(root_dir, config) then
                    config.enabled = false
                end
            end
        )
    end
end

function M.setup(options)
    local nvim_lsp = require("lspconfig")
    local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
    )

    options = vim.tbl_deep_extend("force", {
        servers = {},
        inlay_hints = { enabled = true },
    }, options or {})

    for server_name, server_opts in pairs(options.servers) do
        if server_opts then -- This check is key!
            local final_config = vim.tbl_deep_extend("force", {
                capabilities = capabilities,
                on_attach = function(client)
                    if vim.fn.has("nvim-0.10") == 1 and options.inlay_hints.enabled then
                        if client.supports_method("textDocument/inlayHint") then
                            vim.lsp.inlay_hint.enable(true)
                        end
                    end
                end,
            }, server_opts)

            nvim_lsp[server_name].setup(final_config)
        end
    end
end

M.action = setmetatable({}, {
    __index = function(_, action)
        return function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = { action },
                    diagnostics = {},
                },
            })
        end
    end,
})

return M
