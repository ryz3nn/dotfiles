" 1. Enable ALE's built-in LSP features
let g:ale_lsp_suggestions = 1
let g:ale_completion_enabled = 1

" 2. Define which tools to use
let g:ale_linters = {
\   'go': ['gopls', 'golint'],
\   'html': [],
\   'javascript': ['biome'],
\}

" 3. Fixing (Format on save)
let g:ale_fixers = {
\   'go': ['gofmt'],
\   'html': ['html-beautify'],
\   'javascript': ['biome'],
\}
let g:ale_fix_on_save = 1

" Js-beautify config
let g:ale_javascript_jsbeautify_options = '--indent-size 2'
let g:ale_html_beautify_options = '--indent-size 2 --indent-inner-html'
let g:ale_css_beautify_options = '--indent-size 2'

" 4. Key Mappings (ALE uses different commands than yegappan/lsp)
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gr :ALEFindReferences<CR>
nnoremap K  :ALEHover<CR>
nnoremap gl :ALEDetail<CR>
nnoremap <leader>rn :ALERename<CR>
nnoremap <leader>nd :ALENextWrap<CR>
nnoremap <leader>pd :ALEPreviousWrap<CR>

" 5. Completion (Omnifunc)
" This allows your existing <C-Space> mapping to work with ALE
set omnifunc=ale#completion#OmniFunc

