" Indent Line
set conceallevel=2
set concealcursor=inc
syntax off

" Change the character used for the line
let g:indentLine_char = '│'


" Enable/Disable with a shortcut (e.g., F2)
nnoremap <F2> :IndentLinesToggle<CR>


" OSCYANK
" Configure vim-oscyank to work inside tmx
let g:oscyank_term = 'tmux'

" Automatically copy text to Windows clipboard on yank
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif
