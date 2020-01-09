" make Python follow PEP8
setl softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

" Wrap at 79 chars for comments.
setl formatoptions=cq textwidth=79 foldignore= wildignore+=*.py[co]

" Remove extra space before and after = in selection
command! -range RemoveExtraEqualSpace <line1>,<line2>s/ \+= \+/=/g

map <Leader>d :call InsertPDBLine()<CR>
map <Leader>pep :let g:flake8_on_save = 1

function! InsertPDBLine()
    let trace = expand("import ipdb; ipdb.set_trace()  # FIXME REMOVE")
    execute "normal o".trace
endfunction

autocmd BufWritePost *.py call MaybeFlake8()

" Defaults to being disabled, flake8 is too slow and blocks
let g:flake8_on_save = 0
function! MaybeFlake8()
    if g:flake8_on_save
        call Flake8()
    endif
endfunction

" Show errors in gutter
let g:flake8_show_in_gutter = 1
