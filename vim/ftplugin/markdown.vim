" Better linebreaks for markdown. Does not work with 'list' option
setl nolist linebreak
setl spell

" Fix auto-indentation for lists (plasticboy/vim-markdown installed by
" vim-polyglot)
" See https://github.com/plasticboy/vim-markdown/issues/126
" To check where the config is set:
" verb set flp fo ft inde comments tw
setl comments=b:*,b:-,b:+,b:1.,n:>

" Map <tab> in insert mode in a list (starting with -) to indent
" <c-t> indents, <c-d> unindents in insert mode
" TODO: in normal mode, breaks autocomplete
" inoremap <expr> <tab> getline('.') =~# '^\s*-' ? '<c-t>' : '<tab>'
" inoremap <expr> <s-tab> getline('.') =~# '^\s*-' ? '<c-d>' : '<tab>'
nnoremap <S-Tab> <<
nnoremap <Tab> >>

" Insert bold and italic markers in insert mode (MacVim)
inoremap <D-b> ****<Left><Left>
inoremap <D-i> __<Left>

" Check task items [ ] Todo -> [.] In progress -> [x] Done
function! Checkbox()
    let l:lnum = line('.')
    let l:line = getline(l:lnum)
    let l:curs = winsaveview()

    if l:line =~# '\s*-\s*\[\s*\].*'
        " [ ] -> [x]
        let l:line = substitute(l:line, '\[\s*\]', '[x]', '')
        let l:today = strftime('%Y-%m-%d')
        let l:line = substitute(l:line, 'TODO_DATE', l:today, '')  " first only
        call setline(l:lnum, l:line)
    elseif l:line =~# '\s*-\s*\[\.\].*'
        " [.] -> [ ]
        let l:line = substitute(l:line, '\[.\]', '[ ]', '')
        call setline(l:lnum, l:line)
    elseif l:line =~# '\s*-\s*\[x\].*'
        " [x] -> [.]
        let l:line = substitute(l:line, '\[x\]', '[.]', '')
        call setline(l:lnum, l:line)
    endif

    call winrestview(l:curs)
endfunction

" leader enter marks tasks as done
nnoremap <Leader><Enter> :call Checkbox()<CR>

" Do not conceal code blocks
let g:vim_markdown_conceal_code_blocks = 0
" See conceallevel for help
setl conceallevel=2

" Disable auto-indent for new list items since ContinueProseList() handles it
let g:vim_markdown_new_list_item_indent = 0

" https://github.com/preservim/vim-markdown support folding
" see cheats for keyboard shortcuts
