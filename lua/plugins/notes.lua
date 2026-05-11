-- Floating-window markdown notes.
-- Loaded by lazy.nvim via `{ import = "plugins" }`; registers keymaps and
-- returns an empty plugin spec table.

local M = {}

M.notes_dir = vim.fn.expand("~/notes/")
M.float_config = {
  width = 80,
  height = 20,
  border = "rounded",
  title = " Notes ",
  title_pos = "center",
}

local function ensure_notes_dir()
  if vim.fn.isdirectory(M.notes_dir) == 0 then
    vim.fn.mkdir(M.notes_dir, "p")
    vim.notify("Created notes directory: " .. M.notes_dir, vim.log.levels.INFO)
  end
end

local function todays_notes()
  ensure_notes_dir()
  local prefix = os.date("%d%m%Y") .. "_"
  local out = {}
  for _, fname in ipairs(vim.fn.readdir(M.notes_dir)) do
    if fname:match("^" .. prefix) then
      table.insert(out, fname)
    end
  end
  return out
end

local function next_index()
  local max = 0
  for _, fname in ipairs(todays_notes()) do
    local idx = tonumber(fname:match("^%d+_(%d+)_"))
    if idx and idx > max then
      max = idx
    end
  end
  return max + 1
end

local function generate_filename(custom_name)
  return string.format("%s_%d_%s.md", os.date("%d%m%Y"), next_index(), custom_name)
end

local function slugify(input)
  return input:gsub(" ", "_"):gsub("[^%w_]", ""):lower()
end

-- Open `filepath` in a centred floating window. Reuses the existing buffer for
-- the file if there is one (no E95 from nvim_buf_set_name). On window leave or
-- <esc>, autosaves and closes the window. The <esc> keymap is removed when the
-- floating window closes so the buffer can be reopened normally elsewhere.
local function open_note_float(filepath)
  local bufnr = vim.fn.bufadd(filepath)
  vim.fn.bufload(bufnr)
  vim.bo[bufnr].buflisted = true
  vim.bo[bufnr].filetype = "markdown"

  local win = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = M.float_config.width,
    height = M.float_config.height,
    row = math.floor((vim.o.lines - M.float_config.height) / 2),
    col = math.floor((vim.o.columns - M.float_config.width) / 2),
    style = "minimal",
    border = M.float_config.border,
    title = M.float_config.title,
    title_pos = M.float_config.title_pos,
  })

  local closed = false
  local function close()
    if closed then
      return
    end
    closed = true
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified then
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("silent! write!")
      end)
    end
    pcall(vim.api.nvim_win_close, win, true)
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = bufnr,
    once = true,
    callback = close,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      pcall(vim.keymap.del, "n", "<esc>", { buffer = bufnr })
    end,
  })

  vim.keymap.set("n", "<esc>", close, {
    buffer = bufnr,
    nowait = true,
    desc = "Close floating note",
  })
end

function M.new_note()
  ensure_notes_dir()
  vim.ui.input({ prompt = "Note description: " }, function(input)
    if not input or input == "" then
      return
    end
    local filepath = M.notes_dir .. generate_filename(slugify(input))
    if vim.fn.filereadable(filepath) == 0 then
      vim.fn.writefile({
        "# " .. input,
        "",
        "Created: " .. os.date("%Y-%m-%d %H:%M"),
        "",
        "## Content",
        "",
      }, filepath)
    end
    open_note_float(filepath)
  end)
end

function M.search_notes()
  ensure_notes_dir()
  require("fzf-lua").files({
    cwd = M.notes_dir,
    prompt = "Notes❯ ",
    actions = {
      ["default"] = function(selected)
        if not selected[1] then
          return
        end
        open_note_float(M.notes_dir .. selected[1])
      end,
    },
  })
end

function M.delete_note()
  ensure_notes_dir()
  require("fzf-lua").files({
    cwd = M.notes_dir,
    prompt = "Delete Note❯ ",
    actions = {
      ["default"] = function(selected)
        if not selected[1] then
          return
        end
        local filename = selected[1]
        local filepath = M.notes_dir .. filename
        local choice = vim.fn.confirm("Permanently delete " .. filename .. "?", "&Yes\n&No", 2)
        if choice ~= 1 then
          vim.notify("Note deletion cancelled.", vim.log.levels.WARN)
          return
        end
        -- Wipe out any loaded buffer for the file so it doesn't linger after
        -- the underlying file is gone.
        local bufnr = vim.fn.bufnr(filepath)
        if bufnr ~= -1 then
          pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        end
        local ok, err = os.remove(filepath)
        if ok then
          vim.notify("Deleted note: " .. filename, vim.log.levels.INFO)
        else
          vim.notify("Error deleting note: " .. (err or "unknown"), vim.log.levels.ERROR)
        end
      end,
    },
  })
end

vim.keymap.set("n", "<leader>nn", M.new_note, { silent = true, desc = "New Floating Note" })
vim.keymap.set("n", "<leader>fn", M.search_notes, { silent = true, desc = "Find Notes (fzf-lua)" })
vim.keymap.set("n", "<leader>dn", M.delete_note, { silent = true, desc = "Delete Note" })

return {}
