call plug#begin('~/.local/share/nvim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'mgee/lightline-bufferline'
" Plug 'shinchu/lightline-gruvbox.vim'
" Plug 'kristijanhusak/vim-hybrid-material'
Plug 'sainnhe/gruvbox-material'
" Plug 'arcticicestudio/nord-vim'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
" Plug 'scrooloose/nerdtree'
" Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'google/vim-searchindex'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'zchee/deoplete-clang', { 'for': ['c', 'cpp'] }
Plug 'deoplete-plugins/deoplete-jedi', {'for': 'python' }
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'sirver/ultisnips', { 'for': 'tex' }
" Plug 'kassio/neoterm'
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'sheerun/vim-polyglot'
" Plug 'dense-analysis/ale'
" Plug 'vimsence/vimsence'
call plug#end()

call glaive#Install() " Required for google plugins

let g:deoplete#enable_at_startup = 1
" let g:deoplete#num_processes = 1
let g:deoplete#sources#jedi#enable_typeinfo = 0
let g:deoplete#sources#jedi#show_docstring = 1
" let g:gruvbox_material_transparent_background=1
" VimTeX Settings
let g:tex_flavor='latex'
let g:vimtex_view_general_viewer='mupdf'
let g:vimtex_view_method = 'mupdf'
let g:vimtex_compiler_engine = 'lualatex'
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \    '-synctex=1',
    \ ],
    \}
" UltiSnips Settings
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsSnippetDirectories=['~/.config/nvim/mySnippets']

set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

set nocompatible
set termguicolors

set background=dark
let g:hybrid_custom_term_colors = 1
colorscheme gruvbox-material
syntax enable

set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
au FileType c,cpp setlocal ts=2 sw=2 et
au FileType tex setlocal ts=2 sw=2 tw=120 et
au FileType javascript,typescript setlocal ts=2 sw=2 et
au FileType python setlocal ts=4 sw=4 tw=120 et

let b:ale_linters = {'python': ['pylint']}

set expandtab
set textwidth=80
set t_Co=256
let base16colorspace=256  " Access colors present in 256 colorspace
syntax on

set number
set cursorline
filetype indent on
set lazyredraw
set showmatch
highlight Comment cterm=italic

set incsearch
set hlsearch
set ignorecase
set smartcase
set showmatch
set hlsearch
set hidden

tnoremap <Esc> <C-\><C-n>
nnoremap <tab> %
vnoremap <tab> %

inoremap jk <esc>
let mapleader = ","
nnoremap <leader><space> :noh<cr>
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
nnoremap <leader><leader> :bn<CR>
nnoremap <leader>. :bp<CR>
nnoremap <leader>w :bd<CR>
nnoremap j gj
nnoremap k gk
nnoremap J 5gj
nnoremap K 5gk
nnoremap L g$
nnoremap H g0
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
vnoremap <tab> %
nnoremap <C-S-p> :CtrlPMixed<CR>

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Quit files by typing fjfj quickly, which requires less stretching.
noremap fjfj :q<CR>

" Bind gV so we can re-select pasted text.
nnoremap <expr> gV "`[".getregtype(v:register)[0]."`]"

" Map Ctrl-B to delete to the end of line in insert mode.
inoremap <C-b> <Esc>lDa

" Movement left and right in insert mode with Ctrl.
inoremap <C-l> <Esc>la
inoremap <C-h> <Esc>i

" Disable Ex mode, because fuck Ex mode.
noremap Q <Nop>
" Use semicolons for what colon does.
noremap ; :

" Switch to buffers with leader
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" nnoremap <Leader>t :NERDTreeToggle<CR>

nnoremap <leader>/ :Files<CR>

function! SwitchSourceHeader()
  "update!
  if (expand ("%:e") == "cpp" || expand ("%:e") == "cc" || expand ("%:e") == "c")
    find %:t:r.h
  else
    if filereadable(expand("%:r") . ".cpp")
        find %:t:r.cpp
    elseif filereadable(expand("%:r") . ".cc")
        find %:t:r.cc
    endif
  endif
endfunction

nmap ,s :call SwitchSourceHeader()<CR>

nnoremap <leader>r :echo <C-r><C-w><CR>
function VisualEval()
  " echo eval(@x)
  echo eval(@x)
  let @x = eval(@x)
endfunction
vnoremap <leader>r "xy:call VisualEval()<CR>

set laststatus=2
set showtabline=2

let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox_material'
let g:lightline.tabline          = {'left': [['buffers']], 'right': [[]]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline.component_function = {'filename': 'LightlineFilename'}
function! LightlineFilename()
  return expand('%')
endfunction

let g:goyo_height = "90%"
let g:goyo_width = "30%"

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

let $FZF_DEFAULT_COMMAND = 'ag --nocolor --ignore bazel- --ignore .git -g ""'

Glaive codefmt plugin[mappings]
nnoremap <leader>f :FormatCode<CR>

hi clear SignColumn
set nocursorline

" set guicursor=
" let g:NERDTreeGitStatusIndicatorMapCustom = {
"     \ "Modified"  : "+",
"     \ "Staged"    : "*",
"     \ "Untracked" : "?",
"     \ "Renamed"   : "➜",
"     \ "Unmerged"  : "═",
"     \ "Deleted"   : "x",
"     \ "Dirty"     : "x",
"     \ "Clean"     : "✔",
"     \ 'Ignored'   : '☒',
"     \ "Unknown"   : "?"
"     \ }
autocmd StdinReadPre * let s:std_in=1

set completeopt-=preview

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

" let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$\|\v[\/]node_modules$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-10/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
let g:livepreview_previewer = 'zathura'
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
set mouse=a
au VimSuspend * set guicursor=a:hor10-blinkon0
au VimResume * set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
au VimLeave * set guicursor=a:hor10-blinkon0

augroup neovim_terminal
    autocmd!
    " Enter Terminal-mode (insert) automatically
    autocmd TermOpen * startinsert
    " Disables number lines on terminal buffers
    autocmd TermOpen * :set nonumber norelativenumber
    " allows you to use Ctrl-c on terminal window
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
augroup END

" autocmd VimEnter * call SetupLightlineColors()
" function SetupLightlineColors() abort
"   let l:pallete = lightline#palette()
"   let l:pallete.normal.left[1][3] = 'NONE'
"   call lightline#colorscheme()
" endfunction
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()
