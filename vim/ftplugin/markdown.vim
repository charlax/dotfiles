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
    let l:curs = winsaveview()
    call Checkbox_line(line('.'))
    call winrestview(l:curs)
endfunction

" Toggle checkboxes over a range of lines
function! CheckboxRange() range abort
    for l:lnum in range(a:firstline, a:lastline)
        call Checkbox_line(l:lnum)
    endfor
endfunction

function! Checkbox_line(lnum) abort
    let l:line = getline(a:lnum)
    if l:line =~# '\s*-\s*\[\s*\].*'
        let l:line = substitute(l:line, '\[\s*\]', '[x]', '')
        let l:today = strftime('%Y-%m-%d')
        let l:line = substitute(l:line, 'TODO_DATE', l:today, '')
        call setline(a:lnum, l:line)
    elseif l:line =~# '\s*-\s*\[\.\].*'
        let l:line = substitute(l:line, '\[.\]', '[ ]', '')
        call setline(a:lnum, l:line)
    elseif l:line =~# '\s*-\s*\[x\].*'
        let l:line = substitute(l:line, '\[x\]', '[.]', '')
        call setline(a:lnum, l:line)
    endif
endfunction

" leader enter marks tasks as done (normal and visual)
nnoremap <Leader><Enter> :call Checkbox_line(line('.'))<CR>
xnoremap <Leader><Enter> :call CheckboxRange()<CR>

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
    " Only indent-adjust linewise OS-clipboard pastes in list context
    if empty(l:marker) || getregtype(a:reg) !=# 'V' || (a:reg !=# '+' && a:reg !=# '*')
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

" Listify: convert selected lines into a markdown list.
" Detects indentation from the previous line if it's a list item,
" removes blank lines, and prefixes each line with '- '.
function! Listify() range abort
    let l:prev_lnum = a:firstline - 1
    let l:indent = ''
    if l:prev_lnum >= 1
        let l:prev_line = getline(l:prev_lnum)
        let l:marker = matchstr(l:prev_line, '^\s*[-*+]\s\+\|^\s*\d\+\.\s\+')
        if !empty(l:marker)
            let l:indent = matchstr(l:prev_line, '^\s*')
        endif
    endif

    let l:lines = getline(a:firstline, a:lastline)
    let l:result = []
    for l:line in l:lines
        if l:line =~# '^\s*$'
            continue
        endif
        let l:content = substitute(l:line, '^\s*\(.\{-}\)\s*$', '\1', '')
        call add(l:result, l:indent . '- ' . l:content)
    endfor

    execute a:firstline . ',' . a:lastline . 'delete _'
    call append(a:firstline - 1, l:result)
endfunction

xnoremap <buffer> <Leader>l :call Listify()<CR>

" Text object for markdown emphasis: i* / a* works for *italic* and **bold**
function! s:SelectStar(around) abort
    let l:open = searchpos('\*', 'bcW', line('.'))
    if l:open == [0, 0] | return | endif
    let l:close = searchpos('\*', 'nW', line('.'))
    if l:close == [0, 0] || l:close[1] <= l:open[1] | return | endif

    if a:around
        call cursor(l:open[0], l:open[1])
        normal! v
        call cursor(l:close[0], l:close[1])
    else
        call cursor(l:open[0], l:open[1] + 1)
        normal! v
        call cursor(l:close[0], l:close[1] - 1)
    endif
endfunction

onoremap <buffer> i* :<C-U>call <SID>SelectStar(0)<CR>
xnoremap <buffer> i* :<C-U>call <SID>SelectStar(0)<CR>
onoremap <buffer> a* :<C-U>call <SID>SelectStar(1)<CR>
xnoremap <buffer> a* :<C-U>call <SID>SelectStar(1)<CR>

" https://github.com/preservim/vim-markdown support folding
" see cheats for keyboard shortcuts
