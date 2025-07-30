local M = {}

M.notes_dir = vim.fn.expand("~/notes/")
M.float_config = { width = 80, height = 20, border = "rounded", title = " Notes ", title_pos = "center" }

function M.ensure_notes_dir()
  if vim.fn.isdirectory(M.notes_dir) == 0 then
    vim.fn.mkdir(M.notes_dir, "p")
    vim.notify("Created notes directory: " .. M.notes_dir, vim.log.levels.INFO)
  end
end

local function get_todays_notes()
  M.ensure_notes_dir()
  local date_prefix = os.date("%d%m%Y") .. "_"
  local notes = {}
  for _, fname in ipairs(vim.fn.readdir(M.notes_dir)) do
    if fname:match("^" .. date_prefix) then
      table.insert(notes, fname)
    end
  end
  return notes
end

local function get_next_index()
  local todays_notes = get_todays_notes()
  local max_index = 0
  for _, fname in ipairs(todays_notes) do
    local index = tonumber(fname:match("^%d+_%d+_"))
    if index and index > max_index then
      max_index = index
    end
  end
  return max_index + 1
end

local function generate_filename(custom_name)
  local date_str = os.date("%d%m%Y")
  local index = get_next_index()
  return string.format("%s_%d_%s.md", date_str, index, custom_name)
end

function M.floating_note()
  M.ensure_notes_dir()
  vim.ui.input({ prompt = "Note description: " }, function(input)
    if not input or input == "" then
      return
    end
    local custom_name = input:gsub(" ", "_"):gsub("[^%w_]", ""):lower()
    local filename = generate_filename(custom_name)
    local filepath = M.notes_dir .. filename
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(buf, filepath)
    vim.api.nvim_buf_set_option(buf, "buftype", "")
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    if vim.fn.filereadable(filepath) == 1 then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(filepath))
    else
      vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        { "# " .. input, "", "Created: " .. os.date("%Y-%m-%d %H:%M"), "", "## Content", "" }
      )
    end
    local win = vim.api.nvim_open_win(buf, true, {
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
    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = buf,
      callback = function()
        if vim.api.nvim_buf_get_option(buf, "modified") then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("write!")
          end)
        end
        pcall(vim.api.nvim_win_close, win, {})
      end,
    })
    vim.keymap.set("n", "<esc>", function()
      if vim.api.nvim_buf_get_option(buf, "modified") then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("write!")
        end)
      end
      pcall(vim.api.nvim_win_close, win, {})
    end, { buffer = buf })
  end)
end

function M.search_floating_notes()
  M.ensure_notes_dir()
  require("fzf-lua").files({
    cwd = M.notes_dir,
    prompt = "Notes❯ ",
    actions = {
      ["default"] = function(selected)
        if not selected[1] then
          return
        end
        local filepath = M.notes_dir .. selected[1]
        local buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_name(buf, filepath)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(filepath))
        local win = vim.api.nvim_open_win(buf, true, {
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
        vim.api.nvim_create_autocmd("BufLeave", {
          buffer = buf,
          callback = function()
            if vim.api.nvim_buf_get_option(buf, "modified") then
              vim.api.nvim_buf_call(buf, function()
                vim.cmd("write!")
              end)
            end
            pcall(vim.api.nvim_win_close, win, {})
          end,
        })
        vim.keymap.set("n", "<esc>", function()
          if vim.api.nvim_buf_get_option(buf, "modified") then
            vim.api.nvim_buf_call(buf, function()
              vim.cmd("write!")
            end)
          end
          pcall(vim.api.nvim_win_close, win, {})
        end, { buffer = buf })
      end,
    },
  })
end

function M.delete_note()
  M.ensure_notes_dir()
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
        if choice == 1 then
          local success, err = os.remove(filepath)
          if success then
            vim.notify("Deleted note: " .. filename, vim.log.levels.INFO)
          else
            vim.notify("Error deleting note: " .. (err or "unknown"), vim.log.levels.ERROR)
          end
        else
          vim.notify("Note deletion cancelled.", vim.log.levels.WARN)
        end
      end,
    },
  })
end

return M
