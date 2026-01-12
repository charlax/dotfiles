scriptencoding utf-8

" Filter out .pyc files in NERDTree
let NERDTreeIgnore = ['\.pyc$']

" Only the test file is prefixed with 'test_'
let PyUnitTestsStructure = 'disabled'

" RTFHighlight
let g:rtfh_theme = 'moe'
let g:rtfh_font = 'Consolas'
let g:rtfh_size = '34'

" See https://github.com/jiangmiao/auto-pairs/issues/88, can't type a
" circumflex without this.
let g:AutoPairsShortcutBackInsert=''
let g:AutoPairsShortcutJump=''  " î

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Configuration for vim-gutentags
let g:gutentags_file_list_command = {
 \ 'markers': {
     \ '.git': 'git ls-files',
     \ '.hg': 'hg files',
     \ },
 \ }

" Auto close HTML tags
let g:closetag_filenames = '*.html,*.jsx,*.tsx,*.js'
let g:closetag_regions =  {
\ 'typescript.tsx': 'jsxRegion,tsxRegion',
\ 'typescriptreact': 'jsxRegion,tsxRegion',
\ 'javascript.jsx': 'jsxRegion',
\ }

" Highlight matching HTML tags
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

let g:UltiSnipsSnippetDirectories=['UltiSnips', 'snippets_my']

" =======================================================
" File-specific plugins
" =======================================================

" Note: some of those plugins are installed via Polyglot

" Use two spaces as indent with plasticboy/vim-markdown
let g:vim_markdown_new_list_item_indent = 2

" Use JSX syntax highlighting in all files
let g:jsx_ext_required = 0

" Do not conceal quotes in JSON
let g:vim_json_syntax_conceal = 0

" Latex
" Skim is the default viewer
let g:LatexBox_viewer = 'skim'
" Auto-update when file has changed
let g:LatexBox_latexmk_options = '-pvc'


" =======================================================
" ALE (linting, fixing)
" =======================================================

" Linting
" isort fails as of writing
let g:ale_fixers = {
            \ 'css': ['prettier'],
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
            \ 'python': ['flake8', 'mypy', 'pydocstyle'],
            \}

let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_python_auto_pipenv = 1
let g:ale_python_auto_poetry = 1

function! DisableFixers()
    let g:ale_fix_on_save = 0
endfunction
command! DisableFixers call DisableFixers()

function! EnableFixers()
    let g:ale_fix_on_save = 1
endfunction
command! EnableFixers call EnableFixers()

" Deactivate ALE fixes on non-Code repo
function! DisableFixersOutsideCode()
    if match(expand('%'), 'Code\|dotfiles') == -1
        " echom 'Not in Code or dotfiles, disabling ALE fixers'
        let g:ale_fix_on_save = 0
    else
        " echom 'In Code or dotfiles, enabling ALE fixers'
        let g:ale_fix_on_save = 1
    endif
endfunction

" Run this when opening a file
augroup disablefixers
    autocmd BufNewFile * :call DisableFixersOutsideCode()
augroup END

" =======================================================
" vim-lsp
" =======================================================

" Enable diagnostics (already handled by ALE, so we disable LSP diagnostics)
let g:lsp_diagnostics_enabled = 0
let g:lsp_diagnostics_echo_cursor = 0

" Show diagnostic signs
let g:lsp_signs_enabled = 0

" Enable hover
let g:lsp_hover_ui = 'preview'

" Enable completion
let g:lsp_completion_documentation_enabled = 1

" Disable virtual text (inline diagnostics)
let g:lsp_diagnostics_virtual_text_enabled = 0

" vim-lsp-settings will automatically install language servers
let g:lsp_settings_enable_suggestions = 0

" Register language servers manually for better control
augroup LspSetup
    autocmd!
    if executable('pyright-langserver')
        au User lsp_setup call lsp#register_server({
            \ 'name': 'pyright',
            \ 'cmd': {server_info->['pyright-langserver', '--stdio']},
            \ 'allowlist': ['python'],
            \ 'workspace_config': {'python': {'analysis': {'typeCheckingMode': 'basic'}}}
            \ })
    endif

    if executable('typescript-language-server')
        au User lsp_setup call lsp#register_server({
            \ 'name': 'typescript-language-server',
            \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
            \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), ['package.json', 'tsconfig.json', 'jsconfig.json']))},
            \ 'allowlist': ['typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascript.jsx'],
            \ })
    endif

    if executable('gopls')
        au User lsp_setup call lsp#register_server({
            \ 'name': 'gopls',
            \ 'cmd': {server_info->['gopls']},
            \ 'allowlist': ['go'],
            \ })
    endif
augroup END

" =======================================================
" asyncomplete
" =======================================================

" Enable asyncomplete
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect
let g:asyncomplete_popup_delay = 200

" Register fuzzy file completion source
" VimScript version (slower but works in all Vim versions)
augroup AsyncompleteSetup
    autocmd!
    au User asyncomplete_setup call asyncomplete#register_source(
        \ asyncomplete#sources#fuzzyfile#get_source_options({
        \   'name': 'fuzzyfile',
        \   'allowlist': ['*'],
        \   'completor': function('asyncomplete#sources#fuzzyfile#completor')
        \ }))
augroup END

" Lua version (faster, requires Neovim or Vim with Lua support)
" au User asyncomplete_setup call asyncomplete#register_source(
"     \ asyncomplete#sources#fuzzyfile_lua#get_source_options({
"     \   'name': 'fuzzyfile',
"     \   'allowlist': ['*'],
"     \   'completor': function('asyncomplete#sources#fuzzyfile_lua#completor')
"     \ }))

" =======================================================
" Status line
" =======================================================

function! LightlineFilename()
    " Requires vim-fugitive plugins
    let root = fnamemodify(get(b:, 'git_dir'), ':h')
    let path = expand('%:p')
    if path[:len(root)-1] ==# root
        return path[len(root)+1:]
    endif
    return expand('%')
endfunction

let g:lightline = {
      \ 'colorscheme': 'everforest',
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ }
      \ }

" ale integration
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }
let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ]] }
