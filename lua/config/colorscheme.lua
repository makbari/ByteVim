local M = {}

-- Default colorscheme
M.colorscheme = "catppuccin"

-- Function to load a specific colorscheme
function M.load(colorscheme)
  M.colorscheme = colorscheme or M.colorscheme
  local ok, err = pcall(vim.cmd.colorscheme, M.colorscheme)
  if not ok then
    vim.notify("Failed to load colorscheme: " .. M.colorscheme .. "\n" .. err, vim.log.levels.ERROR)
    vim.cmd.colorscheme("default") -- Fallback colorscheme
  end
end

-- Setup function for initial load
function M.setup()
  M.load(M.colorscheme)
end

return M
