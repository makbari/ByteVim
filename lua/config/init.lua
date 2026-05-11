_G.ByteVim = require("utils")

-- Suppress deprecation warnings from third-party plugins we can't fix upstream.
-- git-conflict.nvim v2.1.0 still uses vim.highlight and vim.validate{...}.
-- Drop the relevant entries here once upstream migrates.
local suppressed_sources = { "git%-conflict" }
local orig_deprecate = vim.deprecate
---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function(name, alternative, version, plugin, backtrace)
  for i = 2, 12 do
    local info = debug.getinfo(i, "S")
    if not info then
      break
    end
    if info.source then
      for _, pat in ipairs(suppressed_sources) do
        if info.source:find(pat) then
          return
        end
      end
    end
  end
  return orig_deprecate(name, alternative, version, plugin, backtrace)
end

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.colorscheme").setup()
