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
