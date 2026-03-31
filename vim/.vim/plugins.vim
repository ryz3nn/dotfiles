" 1. Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" 2. List your plugins here
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'

" 3. Initialize plugin system
call plug#end()
