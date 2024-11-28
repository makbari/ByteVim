
_G.ByteVim = require("utils")
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
-- Load the colorscheme
require("config.colorscheme").setup()
