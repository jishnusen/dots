set nocompatible

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'lervag/vimtex'

" colors
Plug 'mhartington/oceanic-next'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" tpope :goat:
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
call plug#end()

syntax on
set hidden " allow hidden unsaved buffers
set number
if (has("termguicolors"))
 set termguicolors
endif
colorscheme OceanicNext
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set ttimeoutlen=5
filetype plugin indent on

" keymappings
let g:mapleader = " "
nnoremap j gj
nnoremap k gk
nnoremap J 5gj
nnoremap K 5gk
nnoremap L $
nnoremap H ^
nnoremap <Leader><Leader> :bn<CR>
nnoremap <Leader>. :bp<CR>
nnoremap <Leader>w :bd<CR>
nnoremap ; :
nnoremap <Leader>, :ls<CR>:b<Space>
nnoremap Q <nop>
set clipboard=unnamed,unnamedplus

" formatting
"" basic
set textwidth=80 tabstop=2 shiftwidth=2 expandtab
"" real tabs within line
inoremap <Silent> <Tab> <C-R>=(col('.') > (matchend(getline('.'), '^\s*') + 1))?'<C-V><C-V><Tab>':'<Tab>'<CR>
"" autocmds
augroup formatting
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
  autocmd FileType python set ai sw=4 ts=4 sta et fo=croql
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
      "\ Unicode:,
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
local ts_lang = { "lua", "vim", "vimdoc", "python", "query" }

require'nvim-treesitter.configs'.setup {
  -- Modules and its options go here
  ensure_installed = ts_lang,
  highlight = { enable = true }
}
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
