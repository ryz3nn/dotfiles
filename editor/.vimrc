" Options
set history=10000
set noswapfile
set nobackup
set belloff=all
filetype plugin indent on
syntax on
set number
set relativenumber
set nowrap
set hidden
set foldmethod=syntax
set mouse=a
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent
set clipboard=unnamedplus
set backspace=indent,eol,start
set showmatch
set ignorecase
set smartcase
set incsearch
set hlsearch
set wildmenu
set showcmd
set laststatus=2
set statusline=%f\ %h%m%r%=%b\ %l,%c%V\ %P 
set splitright
set splitbelow

" Keymaps
let mapleader = " "
nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p
xnoremap <leader>p "_d"+P

nnoremap <leader>tw :set wrap!<CR>
