setlocal textwidth=79

" t is for hardwrap
setlocal formatoptions+=nt

" http://stackoverflow.com/questions/11115248/smart-hard-wrap-for-list-of-items-in-vim
" http://superuser.com/questions/422214/vim-gq-command-to-re-wrap-paragraph-and-latex
let &l:flp='^\s*\\\(item\|end\|begin\)\s*'
