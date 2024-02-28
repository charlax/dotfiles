" See gvimrc for keyboard shortcuts, cf.
" http://superuser.com/questions/319591/how-can-i-prevent-macvim-from-showing-os-x-find-replace-dialog-when-pressing-co

" Bold
vmap <D-b> c**<C-R>"**<ESC>
" Italic
vmap <D-i> c*<C-R>"*<ESC>

" Indent lines by two spaces
setl shiftwidth=2

" Make sure o include comments character (e.g., list item)
" Need to put in after, for some reason it is overriden
" see :help fo-table
setl formatoptions+=o
