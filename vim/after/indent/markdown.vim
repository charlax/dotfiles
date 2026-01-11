" Override formatoptions set by plugin indent files
" The vim-markdown and vim-polyglot indent/markdown.vim files set formatoptions+=r
" This causes auto-continuation of ALL comment types (including list markers like -)
" We remove 'r' because our ContinueProseList() function handles <CR> in insert mode
setlocal formatoptions-=r
