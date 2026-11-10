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
function! ToggleNetrw()
    for w in getwininfo()
        if getbufvar(w.bufnr, '&filetype') ==# 'netrw'
            execute w.winnr . 'close'
            return
        endif
    endfor

    Vexplore
endfunction

nnoremap <leader>e :call ToggleNetrw()<CR>

" Plugins
" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_keepdir = 0

" Show hidden files
let g:netrw_list_hide = '^\.\.\=/\=$'

" Line numbers
augroup netrw_config
    autocmd!
    autocmd FileType netrw setlocal number relativenumber
    autocmd FileType netrw setlocal cursorline
    autocmd FileType netrw setlocal nowrap
augroup END
