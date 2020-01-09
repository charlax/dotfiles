" Latex
" Skim is the default viewer
let g:LatexBox_viewer = 'skim'
" Auto-update when file has changed
let g:LatexBox_latexmk_options = '-pvc'

" Filter out .pyc files in NERDTree
let NERDTreeIgnore = ['\.pyc$']

" Only the test file is prefixed with 'test_'
let PyUnitTestsStructure = "disabled"

" Do not conceal quotes in JSON
let g:vim_json_syntax_conceal = 0

" RTFHighlight
let g:rtfh_theme = 'moe'
let g:rtfh_font = 'Consolas'
let g:rtfh_size = '34'

" Use ag instead of ack
let g:ackprg = 'ag --vimgrep'

" Use JSX syntax highlighting in all files
let g:jsx_ext_required = 0

" Linting
let g:ale_fixers = {
            \ 'javascript': ['prettier'],
            \ 'javascript.jsx': ['prettier'],
            \ 'typescript': ['prettier'],
            \ 'typescriptreact': ['prettier'],
            \ 'typescript.tsx': ['prettier'],
            \ 'python': ['black'],
            \}
let g:ale_linters = {
            \ 'typescript': ['eslint', 'tsserver', 'typecheck'],
            \ 'typescriptreact': ['eslint', 'tsserver', 'typecheck'],
            \ 'javascript': ['eslint', 'flow'],
            \}

let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_python_auto_pipenv = 1

function! DisableFixers()
    let g:ale_fix_on_save = 0
endfunction
command! DisableFixers call DisableFixers()

" Deoplete
" Inserting on enter is a bit annoying because deoplete is async
let g:deoplete#enable_on_insert_enter = 0

" Disable Deoplete when selecting multiple cursors starts
function! Multiple_cursors_before()
    if exists('*deoplete#disable')
        exe 'call deoplete#disable()'
    elseif exists(':NeoCompleteLock') == 2
        exe 'NeoCompleteLock'
    endif
endfunction

" Enable Deoplete when selecting multiple cursors ends
function! Multiple_cursors_after()
    if exists('*deoplete#toggle')
        exe 'call deoplete#toggle()'
    elseif exists(':NeoCompleteUnlock') == 2
        exe 'NeoCompleteUnlock'
    endif
endfunction

" See https://github.com/jiangmiao/auto-pairs/issues/88, can't type a with
" circumflex without this.
let g:AutoPairsShortcutBackInsert=''

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Configuration for vim-gutentags
let g:gutentags_file_list_command = {
 \ 'markers': {
     \ '.git': 'git ls-files',
     \ '.hg': 'hg files',
     \ },
 \ }

" fzf
" Make :Ag not match file names, only the file content
" https://github.com/junegunn/fzf.vim/issues/346
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

" auto close HTML tags
let g:closetag_filenames = '*.html,*.jsx,*.tsx,*.js'
let g:closetag_regions =  {
\ 'typescript.tsx': 'jsxRegion,tsxRegion',
\ 'typescriptreact': 'jsxRegion,tsxRegion',
\ 'javascript.jsx': 'jsxRegion',
\ }

" highlight matching HTML tags
let g:mta_filetypes = {
            \ 'javascript.jsx': 1,
            \ 'typescript.tsx': 1,
            \ 'typescriptreact': 1,
            \ 'typescript': 1,
            \ 'html' : 1,
            \ 'xhtml' : 1,
            \ 'xml' : 1,
            \ 'jinja' : 1,
            \ }
