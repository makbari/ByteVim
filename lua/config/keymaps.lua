-- Keymaps are automatically loaded on the VeryLazy event

local keymap = vim.keymap.set
local opts = { silent = true }

-- remap "p" in visual mode to delete the highlighted text without overwriting your yanked/copied text, and then paste the content from the unnamed register.
keymap("v", "p", '"_dP', opts)

-- Copy whole file content to clipboard with C-c
keymap("n", "<C-c>", ':%"+y<CR>', opts)
-- Keymap for copying selected text to clipboard
keymap("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })

-- Select all text in buffer with Alt-a
keymap("n", "<A-a>", "ggVG", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Move to start/end of line
keymap({ "n", "x", "o" }, "H", "^", opts)
keymap({ "n", "x", "o" }, "L", "g_", opts)
-- Jump to next search result and center screen
keymap("n", "n", "nzzv", opts)

-- Jump to previous search result and center screen
keymap("n", "N", "Nzzv", opts)

-- Search forward for the word under cursor and center screen
keymap("n", "*", "*zzv", opts)

-- Search backward for the word under cursor and center screen
keymap("n", "#", "#zzv", opts)

-- Search forward for partial word under cursor and center screen
keymap("n", "g*", "g*zz", opts)

-- Search backward for partial word under cursor and center screen
keymap("n", "g#", "g#zz", opts)
