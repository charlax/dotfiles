" make Python follow PEP8
setl softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

" Wrap at 79 chars for comments.
setl formatoptions=cq textwidth=79 foldignore= wildignore+=*.py[co]

" Remove extra space before and after = in selection
command! -range RemoveExtraEqualSpace <line1>,<line2>s/ \+= \+/=/g

" Keys

" Add debugger
map <Leader>d :call InsertPDBLine()<CR>

function! InsertPDBLine()
    let trace = expand("import ipdb; ipdb.set_trace()  # FIXME REMOVE")
    execute "normal o".trace
endfunction
