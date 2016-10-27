"   Cheat Sheet
"   Ctrl+w, =       equal sized splits
"   Ctrl+w, +/-     height resize    
"   Ctrl+, </>      width resize    
"   "=y             yank to buffer
"   :tabm +i        move tab
let mapleader = ","

nnoremap <leader>vi :tabnew ~/.vimrc<CR>
nnoremap <leader>zs :tabnew ~/.zshrc<CR>
nnoremap <leader>ba :tabnew ~/.bashrc<CR>
nnoremap <leader>tm :tabnew ~/.tmux.conf<CR>

nnoremap <tab> :tabn<CR>
nnoremap <S-tab> :tabp<CR>
nnoremap <c-s> :wa<CR>
inoremap <c-s> <Esc>:wa<CR>

set nocompatible                " be iMproved, required
filetype off                    " required

syntax on

" Line nr
set relativenumber
set number

" size of a hard tab stop
set tabstop=4

" size of an indent
set shiftwidth=4

" make "tab" insert indents instead of tabs at the beginning of a line
set smarttab

" always uses spaces instead of tab characters
set expandtab

" Nautral splitopening
set splitbelow
set splitright

" Always show status line
set laststatus=2

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" PLUGINS

"---------- Core ----------
Plugin 'christoomey/vim-tmux-navigator'

"---------- Peripheral ----------
Plugin 'scrooloose/nerdtree'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-obsession'
Plugin 'lervag/vimtex'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_view_general_options_latexmk = '-r 1'

"---------- Look ----------
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1
let g:airline_theme='distinguished'
set background=dark
color grb256

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
