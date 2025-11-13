if vim.version().minor >= 11 then
  vim.tbl_add_reverse_lookup = function(tbl)
    for k, v in pairs(tbl) do
      tbl[v] = k
    end
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.extras.typescript" },
    { import = "plugins.extras.deno" },
    { import = "plugins.extras.rust" },
    { import = "plugins.extras.go" },
    { import = "plugins.extras.markdown" },
    { import = "plugins.extras.docker" },
    -- { import = "plugins.extras.vue" },
    { import = "plugins.extras.angular" },
    { import = "plugins.extras.react" },
    { import = "plugins.extras.gitlab" },
    { import = "plugins.extras.tailwindcss" },
    { import = "plugins.extras.html" },
    { import = "plugins.extras.http-client" },
  },
  checker = { enabled = false },
  change_detection = { enabled = true, notify = false },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  diff = { cmd = "diffview.nvim" },
  ui = {
    border = vim.g.border_enabled and "rounded" or "none",
    icons = { ft = "", lazy = "󰂠 ", loaded = "", not_loaded = "" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})
