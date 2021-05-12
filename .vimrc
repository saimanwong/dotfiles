"   Cheat Sheet
"   Ctrl+w, =       equal sized splits
"   Ctrl+w, +/-     height resize
"   Ctrl+, </>      width resize
"   "=y             yank to buffer
"   :tabm +i        move tab
let mapleader = ","
set backspace=indent,eol,start

nnoremap <leader>vi :tabnew ~/.vimrc<CR>
nnoremap <leader>zs :tabnew ~/.zshrc<CR>
nnoremap <leader>ba :tabnew ~/.bashrc<CR>
nnoremap <leader>tm :tabnew ~/.tmux.conf<CR>
nnoremap <leader>xc :tabnew ~/.xvimrc<CR>
nnoremap <leader>us :setlocal spell spelllang=en_us<CR>
nnoremap <leader>no :setlocal nospell<CR>
nnoremap <leader>to :VimtexTocToggle<CR>
nnoremap <leader>tr :%s/\s\+$//<CR>
nnoremap <leader>ne :NERDTree<CR>

nnoremap <tab> :tabn<CR>
nnoremap <S-tab> :tabp<CR>
nnoremap <c-s> :wa<CR>
inoremap <c-s> <Esc>:wa<CR>

" Jupyter
" Run current file
nnoremap <leader>jr :JupyterRunFile<CR>
nnoremap <leader>ji :PythonImportThisFile<CR>

" Change to directory of current file
nnoremap <leader>jd :JupyterCd %:p:h<CR>

" Send a selection of lines
nnoremap <leader>jX :JupyterSendCell<CR>
nnoremap <leader>jE :JupyterSendRange<CR>
nmap     <leader>je <Plug>JupyterRunTextObj
vmap     <leader>je <Plug>JupyterRunVisual

nnoremap <leader>jU :JupyterUpdateShell<CR>

" Debugging maps
nnoremap <leader>jb :PythonSetBreak<CR>


set nocompatible " be iMproved, required
" filetype off " required

" Match tags %
runtime macros/matchit.vim

" Line nr
set relativenumber
set number

" size of a hard tab stop
set tabstop=2

" size of an indent
set shiftwidth=2

" make "tab" insert indents instead of tabs at the beginning of a line
set smarttab

" always uses spaces instead of tab characters
set expandtab
au BufNewFile,BufRead *.go setlocal noet ts=8 sw=8 sts=8

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
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-obsession'
Plugin 'lervag/vimtex'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_view_general_options_latexmk = '-r 1'
let g:vimtex_compiler_latexmk = {'callback' : 0}

Plugin 'maxmellon/vim-jsx-pretty'

Plugin 'posva/vim-vue'
" Vue syntax highligting
autocmd BufNewFile,BufRead *.vue set ft=vue

Plugin 'leafgarland/typescript-vim'
autocmd BufNewFile,BufRead *.ts set ft=typescript

Plugin 'hashivim/vim-terraform'
Plugin 'fatih/vim-go'
let g:go_autodetect_gopath = 1

Plugin 'rodjek/vim-puppet'
Plugin 'hashivim/vim-hashicorp-tools'

Plugin 'python-mode/python-mode'

Plugin 'cespare/vim-toml.git'

Plugin 'jupyter-vim/jupyter-vim'

"---------- Look ----------
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_theme = 'bubblegum'

set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
color hybrid
" color nofrils-dark

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
syntax enable
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
