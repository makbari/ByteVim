-- lua/utils/lsp.lua
local M = {}

local Path = require("utils.path")
local util = require("lspconfig.util")

---@param opts? {id?: number, bufnr?: number, name?: string, method?: string, filter?: fun(client: vim.lsp.Client): boolean}
function M.get_clients(opts)
  opts = opts or {}
  local ret = vim.lsp.get_clients()
  if opts.method then
    ret = vim.tbl_filter(function(client)
      return client:supports_method(opts.method, { bufnr = opts.bufnr })
    end, ret)
  end
  if opts.filter then
    ret = vim.tbl_filter(opts.filter, ret)
  end
  return ret
end

---@param on_attach fun(client: vim.lsp.Client, buffer: number)
---@param name? string
function M.on_attach(on_attach, name)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        on_attach(client, buffer)
      end
    end,
  })
end

function M.setup()
  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    local ret = register_capability(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspDynamicCapability",
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end
  M.on_attach(function(client, buffer)
    M._check_methods(client, buffer)
  end)
end

M._supports_method = {}
function M._check_methods(client, buffer)
  if not vim.api.nvim_buf_is_valid(buffer) or not vim.bo[buffer].buflisted or vim.bo[buffer].buftype == "nofile" then
    return
  end
  for method, clients in pairs(M._supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] and client:supports_method(method, { bufnr = buffer }) then
      clients[client][buffer] = true
      vim.api.nvim_exec_autocmds("User", {
        pattern = "LspSupportsMethod",
        data = { client_id = client.id, buffer = buffer, method = method },
      })
    end
  end
end

---@param method string
---@param fn fun(client: vim.lsp.Client, buffer: number)
function M.on_supports_method(method, fn)
  M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
  vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer
      if client and method == args.data.method then
        fn(client, buffer)
      end
    end,
  })
end

function M.get_config(server)
  return rawget(require("lspconfig.configs"), server)
end

function M.is_enabled(server)
  local c = M.get_config(server)
  return c and c.enabled ~= false
end

---@param server string
---@param cond fun(root_dir: string, config: table): boolean
function M.disable(server, cond)
  local def = M.get_config(server)
  if def then
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

function M.deno_config_exist()
  return M.get_config_path("deno.json") ~= nil
    or M.get_config_path("deno.jsonc") ~= nil
    or M.get_config_path("import_map.json") ~= nil
end

function M.eslint_config_exists()
  local config_files = {
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    ".eslintrc",
    "eslint.config.mjs",
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

function M.stop_lsp_client_by_name(name)
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == name then
      vim.lsp.stop_client(client.id, true)
      return
    end
  end
end

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { action }, diagnostics = {} },
      })
    end
  end,
})

return M
