set nocompatible              " be iMproved, required
filetype off                  " required

if $TERM_PROGRAM != 'Apple_Terminal'
    set termguicolors
endif

if exists('+termguicolors') && ($TERM == "st-256color" || $TERM == "tmux-256color")
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif


" ----------------------------------------
" Plugins
" ----------------------------------------

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'arithran/vim-delete-hidden-buffers'
Plugin 'djoshea/vim-autoread'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'phanviet/vim-monokai-pro'
Plugin 'sheerun/vim-polyglot'

call vundle#end()            " required
filetype plugin indent on    " required


" ----------------------------------------
" Plugin Settings
" ----------------------------------------

" vim-delete-hidden-buffers
nnoremap <F5> :DeleteHiddenBuffers<CR>

" vim-autoread
set autoread

" supertab
let g:SuperTabDefaultCompletionType = "context"

" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 0

" vim-fugitive
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

" ctrlp
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'


" ----------------------------------------
" Non-Plugin Settings
" ----------------------------------------

colorscheme monokai_pro

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" Highlight current line
set cursorline

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
" set ignorecase
" set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Disable autocomment new line
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a
set ttymouse=sgr

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
" nnoremap <Left>  :echoe "Use h"<CR>
" nnoremap <Right> :echoe "Use l"<CR>
" nnoremap <Up>    :echoe "Use k"<CR>
" nnoremap <Down>  :echoe "Use j"<CR>
" " ...and in insert mode
" inoremap <Left>  <ESC>:echoe "Use h"<CR>
" inoremap <Right> <ESC>:echoe "Use l"<CR>
" inoremap <Up>    <ESC>:echoe "Use k"<CR>
" inoremap <Down>  <ESC>:echoe "Use j"<CR>

" pwd follows file that is edited
set autochdir

" hightlight search items
set hlsearch
nnoremap <Leader><space> :noh<cr>

" Disable word wrap, press f2 to toggle
set nowrap
nnoremap <silent><expr> <f2> ':set wrap! go'.'-+'[&wrap]."=b\r"

" reindent blocks
vnoremap < <gv
vnoremap > >gv

" toggle paste mode
set pastetoggle=<F3>

" terminal normal mode on <esc>
tnoremap <Esc> <C-\><C-n>



" ----------------------------------------
" File(type) specific settings
" ----------------------------------------

" treat justfile as yaml
au BufNewFile,BufRead,BufReadPost justfile set syntax=yaml
