local M = {}

-- Global versions for plugins
M.versions = {
  lspconfig = "v2.4.0",
}

setmetatable(M, {
  __index = function(t, k)
    -- Check if the utility module is already loaded
    if rawget(t, k) then
      return rawget(t, k)
    end

    -- Dynamically require the utility module
    local success, mod = pcall(require, "utils." .. k)
    if success then
      t[k] = mod -- Cache the module for future accesses
      return mod
    else
      error("Module 'utils." .. k .. "' not found: " .. mod)
    end
  end,
})

return M
