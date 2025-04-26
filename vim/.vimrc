" Enable line numbers
set number

" Highlight current line
set cursorline

" Enable syntax highlighting
syntax on
" No backup file 
set noswapfile
set nobackup

" Set indentation
set tabstop=2       " Number of spaces a tab counts for
set shiftwidth=2    " Number of spaces to use for autoindent
set expandtab       " Convert tabs to spaces
set smartindent

" Enable line wrapping
set wrap

" Show matching brackets
set showmatch

" Enable mouse support
"set mouse=a

" Enable clipboard access (requires +clipboard build)
set clipboard=unnamedplus

" Set a better backspace behavior
set backspace=indent,eol,start

" Search settings
set ignorecase      " Case-insensitive search
set smartcase       " But case-sensitive if you use capital letters
set incsearch       " Show matches while typing
set hlsearch        " Highlight matches

" Better command line completion
set wildmenu

" Set colorscheme (optional, change or remove if not installed)
colorscheme desert

