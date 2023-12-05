local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","
require("lazy").setup(
  {
    { import = "plugins" },
  },
  {
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  }
)

-- appearance
vim.wo.number = true

-- keymappings
local function noremap(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command, { noremap = true })
end
noremap("n", "j", "gj")
noremap("n", "k", "gk")
noremap("n", "J", "5gj")
noremap("n", "K", "5gk")
noremap("n", "L", "$")
noremap("n", "H", "^")
noremap("n", "<Leader><Leader>", ":bn<CR>")
noremap("n", "<Leader>.", ":bp<CR>")
noremap("n", "<Leader>w", ":bd<CR>")

-- indent behavior
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})
