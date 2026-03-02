set history=10000
set noswapfile
set nobackup
set belloff=all

syntax off
set number
set relativenumber
set wrap

" set cursorline
set hidden " Change buffer without save
set foldmethod=indent
set nofoldenable
set cursorline
set mouse=a
set tabstop=2       " Number of spaces a tab counts for
set shiftwidth=2    " Number of spaces to use for autoindent
set expandtab       " Convert tabs to spaces
set smartindent
set autoindent

set clipboard=unnamedplus
set backspace=indent,eol,start
set mouse=a

set showmatch
set ignorecase      " Case-insensitive search
set smartcase       " But case-sensitive if you use capital letters
set incsearch       " Show matches while typing
set hlsearch        " Highlight matches

set wildmenu
set showcmd
set laststatus=2 " Always show the statusline
set statusline=%f\ %h%m%r%=%b\ %l,%c%V\ %P " Basic statusline displaying file name, flags, byte/line/column info, and percentage

" Customize

" Delete to blackhole
nnoremap x "_x
nnoremap d "_d
vnoremap d "_d

" mapping unfold/fold all to zo, zc
nnoremap zo zR
nnoremap zc zM
nnoremap za zA
