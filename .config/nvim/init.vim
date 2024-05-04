set nocompatible

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'lervag/vimtex', { 'for': ['tex'] }
Plug 'justinmk/vim-sneak'

" colors
Plug 'miikanissi/modus-themes.nvim'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" NVIM lang helpers
Plug 'williamboman/mason.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" tpope :goat:
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
call plug#end()

syntax on
set hidden " allow hidden unsaved buffers
set number
set title
if (has("termguicolors"))
 set termguicolors
endif
" colorscheme OceanicNext
" colorscheme catppuccin-latte
set background=light
colorscheme modus_operandi
set cursorline
set ttimeoutlen=5
filetype plugin indent on

" keymappings
let g:mapleader = " "
let g:sneak#s_next = 1
nnoremap j gj
nnoremap k gk
nnoremap J 5gj
nnoremap K 5gk
nnoremap L $
nnoremap H ^
nnoremap <Leader><Leader> :Files<CR>
nnoremap <Leader>. :execute "Files " . GetCurrentDirectory()<CR>
nnoremap <Leader>/ :RG<CR>
nnoremap <Leader>w :bd<CR>
nnoremap ; :
nnoremap <Leader>, :Buffers<CR>
nnoremap Q <nop>
nnoremap f <Plug>Sneak_f
nnoremap F <Plug>Sneak_F
nnoremap t <Plug>Sneak_t
nnoremap T <Plug>Sneak_T
highlight Sneak gui=underline cterm=underline ctermfg=red guifg=red ctermbg=None guibg=None
set clipboard=unnamed,unnamedplus

" formatting
"" basic
set textwidth=80 tabstop=8 shiftwidth=2 expandtab
"" real tabs within line
inoremap <Silent> <Tab> <C-R>=(col('.') > (matchend(getline('.'), '^\s*') + 1))?'<C-V><C-V><Tab>':'<Tab>'<CR>
"" autocmds
augroup formatting
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
  autocmd FileType python set ai sw=4 ts=4 sta et fo=croql
  autocmd FileType c set ai sw=8 ts=8 noet
augroup END

augroup appearance
  autocmd!
  autocmd FileType tex set conceallevel=2 concealcursor=nc
augroup END

" plugins
"" vimtex
let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-xelatex',
    \}
let g:vimtex_syntax_custom_cmds = [
      \ {'name': 'bm'  , 'mathmode': 1, 'argstyle': 'bold', 'conceal': 1},
      \ {'name': 'R'   , 'mathmode': 1, 'concealchar': 'ℝ'},
      \ {'name': 'N'   , 'mathmode': 1, 'concealchar': 'ℕ'},
      \ {'name': 'Z'   , 'mathmode': 1, 'concealchar': 'ℤ'},
      \ {'name': 'Q'   , 'mathmode': 1, 'concealchar': 'ℚ'},
      \]
augroup vimtex
  autocmd!
  autocmd User VimtexEventView call b:vimtex.viewer.xdo_focus_vim()
augroup END

" TS
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = { enable = true, disable = { "java", "latex", "tex", "cpp", "html" } }
}
EOF

" LSP
lua << EOF
require('mason').setup {}
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
EOF

set statusline=
set statusline+=\ %{mode()}
set statusline+=\ %f%{&modified?'[+]':''}
set statusline+=\ %l:%c
set statusline+=\ %p%%
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileformat}
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ \ %{FugitiveStatusline()}
set laststatus=2


" Utils
function! GetCurrentDirectory()
    " Get the full path of the current file
    let current_file = expand("%:p")

    " Extract the directory part
    let current_directory = fnamemodify(current_file, ":h")

    return current_directory
endfunction
