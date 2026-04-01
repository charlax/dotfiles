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

" Smart paste: indent each pasted line to match the current list item's
" content column when pasting linewise into a list context.
function! SmartMarkdownPaste(reg, cmd) abort
    let l:line = getline('.')
    " Match list markers: unordered (-, *, +) or ordered (1.)
    let l:marker = matchstr(l:line, '^\s*[-*+]\s\+\|^\s*\d\+\.\s\+')
    " Only indent-adjust linewise registers in list context
    if empty(l:marker) || getregtype(a:reg) !=# 'V'
        execute 'normal! "' . a:reg . a:cmd
        return
    endif

    let l:lines = getreg(a:reg, 1, 1)
    " If pasted content is itself a list, paste as-is
    let l:first = get(filter(copy(l:lines), '!empty(v:val)'), 0, '')
    if l:first =~# '^\s*[-*+]\s\+\|^\s*\d\+\.\s\+'
        execute 'normal! "' . a:reg . a:cmd
        return
    endif

    let l:indent = repeat(' ', len(l:marker))
    let l:indented = map(copy(l:lines), 'empty(v:val) ? v:val : l:indent . v:val')

    " Stash and restore @z so we don't clobber it
    let l:save_z = getreg('z', 1, 1)
    let l:save_z_type = getregtype('z')
    call setreg('z', l:indented, 'V')
    execute 'normal! "z' . a:cmd
    call setreg('z', l:save_z, l:save_z_type)
endfunction

nnoremap <buffer> p :<C-U>call SmartMarkdownPaste(v:register, 'p')<CR>
nnoremap <buffer> P :<C-U>call SmartMarkdownPaste(v:register, 'P')<CR>
nnoremap <buffer> <D-v> :<C-U>call SmartMarkdownPaste('+', 'p')<CR>

" https://github.com/preservim/vim-markdown support folding
" see cheats for keyboard shortcuts
