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
set foldmethod=indent
set foldlevel=99
set foldnestmax=1
set foldminlines=3
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
set path+=**
set wildmenu
set wildmode=longest:full,full
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

nnoremap <leader>wt :set wrap!<CR>
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
nnoremap <C-q> :q!<CR>
nnoremap <leader>t :ter<CR>

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

" LSP - clangd
if executable('clangd')
    augroup clangd_config
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->['clangd', '--background-index', '--compile-commands-dir=./build']},
            \ 'allowlist': ['c'],
            \ })
    augroup END
endif

" LSP buffer settings
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes

    " Navigation
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> K <plug>(lsp-hover)

    " Rename
    nmap <buffer> <leader>rn <plug>(lsp-rename)

    " Diagnostics
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
endfunction

augroup lsp_config
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
