local M = {}

-- Configuration
M.notes_dir = vim.fn.expand("~/notes/")
M.float_config = {
    width = 80,
    height = 20,
    border = "rounded",
    title = " Notes ",
    title_pos = "center",
}

-- Ensure the notes directory exists
function M.ensure_notes_dir()
    -- The 'p' flag in mkdir creates parent directories if they don't exist, similar to `mkdir -p`
    if vim.fn.isdirectory(M.notes_dir) == 0 then
        vim.fn.mkdir(M.notes_dir, "p")
        vim.notify("Created notes directory: " .. M.notes_dir, vim.log.levels.INFO)
    end
end

-- Get all note files for today
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

-- Generate the next available index for today's notes
local function get_next_index()
    local todays_notes = get_todays_notes()
    local max_index = 0

    for _, fname in ipairs(todays_notes) do
        local index = tonumber(fname:match("^%d+_(%d+)_"))
        if index and index > max_index then
            max_index = index
        end
    end

    return max_index + 1
end

-- Generate filename with date and auto-index
local function generate_filename(custom_name)
    local date_str = os.date("%d%m%Y")
    local index = get_next_index()
    return string.format("%s_%d_%s.md", date_str, index, custom_name)
end

-- Modified floating_note function with auto-naming
function M.floating_note()
    M.ensure_notes_dir()

    vim.ui.input({ prompt = "Note description: " }, function(input)
        if not input or input == "" then
            return
        end

        -- Generate filename
        local custom_name = input:gsub(" ", "_"):gsub("[^%w_]", ""):lower()
        local filename = generate_filename(custom_name)
        local filepath = M.notes_dir .. filename

        -- Rest of the existing implementation...
        local buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_name(buf, filepath)
        vim.api.nvim_buf_set_option(buf, "buftype", "")
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

        if vim.fn.filereadable(filepath) == 1 then
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(filepath))
        else
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
                "# " .. input,
                "",
                "Created: " .. os.date("%Y-%m-%d %H:%M"),
                "",
                "## Content",
                "",
            })
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

        -- ... (keep the rest of your existing save/close logic)
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

        vim.keymap.set("n", "<ESC>", function()
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
                if not selected[1] then return end
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

                -- Same save/close logic as above
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

                vim.keymap.set("n", "<ESC>", function()
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
                if not selected[1] then return end
                local filename = selected[1]
                local filepath = M.notes_dir .. filename

                -- Use vim.fn.confirm, which is not affected by telescope-ui-select
                local choice = vim.fn.confirm("Permanently delete " .. filename .. "?", "&Yes\n&No", 2)

                if choice == 1 then -- 1 is the first choice, "Yes"
                    local success, err = pcall(os.remove, filepath)
                    if success then
                        vim.notify("Deleted note: " .. filename, vim.log.levels.INFO)
                    else
                        vim.notify("Error deleting note: " .. err, vim.log.levels.ERROR)
                    end
                else
                    vim.notify("Note deletion cancelled.", vim.log.levels.WARN)
                end
            end,
        },
    })
end

return M
