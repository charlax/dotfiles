" Better linebreaks for markdown. Does not work with 'list' option
setl nolist linebreak
setl spell

" Fix auto-indentation for lists (plasticboy/vim-markdown installed by
" vim-polyglot)
" See https://github.com/plasticboy/vim-markdown/issues/126
" To check where the config is set:
" verb set flp fo ft inde comments tw
setl formatoptions+=ro
setl comments=b:*,b:-,b:+,b:1.,n:>

" Map <tab> in insert mode in a list (starting with -) to indent
" <c-t> indents, <c-d> unindents in insert mode
" TODO: in normal mode, breaks autocomplete
" inoremap <expr> <tab> getline('.') =~# '^\s*-' ? '<c-t>' : '<tab>'
" inoremap <expr> <s-tab> getline('.') =~# '^\s*-' ? '<c-d>' : '<tab>'
nnoremap <S-Tab> <<
nnoremap <Tab> >>

" Check task items [ ] Todo -> [.] In progress -> [x] Done
function Checkbox()
    let l:line=getline('.')
    let l:curs=winsaveview()  " saves cursor position
    if l:line=~?'\s*-\s*\[\s*\].*'
        s/\[\s*\]/[x]/
    elseif l:line=~?'\s*-\s*\[\.\].*'
        s/\[.\]/[ ]/
    elseif l:line=~?'\s*-\s*\[x\].*'
        s/\[x\]/[.]/
    endif
    call winrestview(l:curs)  " restores cursor position
endfunction

" leader enter marks tasks as done
nnoremap <Leader><Enter> :call Checkbox()<CR>

" Do not conceal code blocks
let g:vim_markdown_conceal_code_blocks = 0
" See conceallevel for help
setl conceallevel=2

let g:vim_markdown_new_list_item_indent = 2

" https://github.com/preservim/vim-markdown support folding
" see cheats for keyboard shortcuts
