local M = {}

function M.is_list(t)
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end
  return true
end

local function can_merge(v)
  return type(v) == "table" and (vim.tbl_isempty(v) or not M.is_list(v))
end

function M.merge(...)
  local ret = select(1, ...)
  if ret == vim.NIL then
    ret = nil
  end
  for i = 2, select("#", ...) do
    local value = select(i, ...)
    if can_merge(ret) and can_merge(value) then
      for k, v in pairs(value) do
        ret[k] = M.merge(ret[k], v)
      end
    elseif value == vim.NIL then
      ret = nil
    elseif value ~= nil then
      ret = value
    end
  end
  return ret
end

function M.keymap(keys, func, desc, mode, opts)
  opts = M.merge({ silent = true, noremap = true }, opts or {})
  mode = mode or "n"
  vim.keymap.set(mode, keys, func, M.merge({ desc = desc }, opts))
end

function M.execute(opts)
  local params = { command = opts.command, arguments = opts.arguments }
  return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
end

return M
