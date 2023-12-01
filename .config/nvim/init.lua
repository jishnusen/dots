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

require("lazy").setup({
  { "folke/tokyonight.nvim", lazy = false },
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'}
})
require("bufferline").setup{}

-- appearance
vim.cmd.colorscheme("tokyonight-night")
vim.wo.number = true

-- keymappings
vim.g.mapleader = ","
function noremap(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command, { noremap = true })
end
noremap("n", "J", "5j")
noremap("n", "K", "5k")
noremap("n", "L", "$")
noremap("n", "H", "^")
noremap("n", "<Leader><Leader>", ":bn<CR>")
noremap("n", "<Leader>.", ":bp<CR>")
noremap("n", "<Leader>w", ":bd<CR>")

-- indent behavior
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

