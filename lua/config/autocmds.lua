-- Define a helper function to create augroups
local function augroup(name)
return vim.api.nvim_create_augroup("bytevim_" .. name, { clear = true })
end

-- Autocommands
-- Check if the file needs to be reloaded
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
group = augroup("checktime"),
callback = function()
    if vim.o.buftype ~= "nofile" then
    vim.cmd("checktime")
    end
end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
group = augroup("highlight_yank"),
callback = function()
    (vim.hl or vim.highlight).on_yank()
end,
})

-- Resize splits if the window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
group = augroup("resize_splits"),
callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
end,
})

-- Go to the last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
group = augroup("last_loc"),
callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].bytevim_last_loc then
    return
    end
    vim.b[buf].bytevim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
end,
})

-- Close certain filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
group = augroup("close_with_q"),
pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "snacks_win",
    "spectre_panel",
    "startuptime",
    "tsplayground",
},
callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
    vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
    end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
    })
    end)
end,
})

-- Make man pages easier to close
vim.api.nvim_create_autocmd("FileType", {
group = augroup("man_unlisted"),
pattern = { "man" },
callback = function(event)
    vim.bo[event.buf].buflisted = false
end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
group = augroup("wrap_spell"),
pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
end,
})

-- Fix conceallevel for JSON files
vim.api.nvim_create_autocmd({ "FileType" }, {
group = augroup("json_conceal"),
pattern = { "json", "jsonc", "json5" },
callback = function()
    vim.opt_local.conceallevel = 0
end,
})

-- Auto-create directories when saving files
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
group = augroup("auto_create_dir"),
callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
    return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
end,
})
