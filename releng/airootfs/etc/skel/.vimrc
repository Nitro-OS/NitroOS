set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

" Core plugins
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'

" UI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'

" Search / fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Linting
Plug 'dense-analysis/ale'

call plug#end()

filetype plugin indent on

" BASIC SETTINGS
set number
set relativenumber

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

set clipboard=unnamedplus
set mouse=a
set cursorline

set ignorecase
set smartcase
set incsearch
set hlsearch

set splitbelow
set splitright

set updatetime=300
set timeoutlen=500

set laststatus=2
set termguicolors
syntax on

colorscheme onedark

" LEADER KEY
let mapleader=" "

" KEYBINDINGS
nnoremap <leader>e :NERDTreeToggle<CR>
nmap <leader>/ <Plug>NERDCommenterToggle
nnoremap <leader>f :Files<CR>

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" PLUGIN SETTINGS
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1

let g:gitgutter_enabled = 1
