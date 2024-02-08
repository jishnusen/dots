lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
print(lazypath)
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

vim.g.mapleader = " "
vim.g.maplocalleader = ","
require("lazy").setup(
  {
    { import = "plugins" },
  },
  {
    dev = {
      path = "~/Documents/nvim",
    },
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
EOF

" appearance
set number
set termguicolors

" keymappings
nnoremap j gj
nnoremap k gk
nnoremap J 5gj
nnoremap K 5gk
nnoremap L $
nnoremap H ^
nnoremap <Leader><Leader> :bn<CR>
nnoremap <Leader>. :bp<CR>
nnoremap <Leader>w :bd<CR>
noremap("n", ";", ":")
set clipboard=unnamedplus

" formatting
"" basic
set textwidth=80 tabstop=2 shiftwidth=2 expandtab
"" real tabs within line
inoremap <Silent> <Tab> <C-R>=(col('.') > (matchend(getline('.'), '^\s*') + 1))?'<C-V><C-V><Tab>':'<Tab>'<CR>
"" autocmds
augroup formatting
  autocmd BufWritePre * :%s/\s\+$//e
  autocmd FileType python set ai sw=4 ts=4 sta et fo=croql
augroup END

