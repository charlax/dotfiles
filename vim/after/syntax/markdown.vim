" Priority task highlighting for markdown files
" Define syntax patterns for priority tasks
syntax match markdownTaskP0 /^\s*- \[.\] P0\s.*$/ contains=markdownTaskP0Priority
syntax match markdownTaskP1 /^\s*- \[.\] P1\s.*$/ contains=markdownTaskP1Priority
syntax match markdownTaskP2 /^\s*- \[.\] P2\s.*$/ contains=markdownTaskP2Priority

" Define the priority labels themselves for more specific styling
syntax match markdownTaskP0Priority /P0/ contained
syntax match markdownTaskP1Priority /P1/ contained
syntax match markdownTaskP2Priority /P2/ contained

" Define highlight groups with the requested colors
highlight markdownTaskP0Priority ctermbg=Red ctermfg=White guibg=Red guifg=White
highlight markdownTaskP1Priority ctermfg=DarkYellow guifg=Orange
highlight markdownTaskP2Priority ctermfg=DarkGreen guifg=DarkGreen

" Highlight completed priority tasks differently - dim the entire line
syntax match markdownTaskP0Done /^\s*- \[x\] P0\s.*$/
syntax match markdownTaskP1Done /^\s*- \[x\] P1\s.*$/
syntax match markdownTaskP2Done /^\s*- \[x\] P2\s.*$/

" Dim entire completed task lines
highlight markdownTaskP0Done ctermfg=Gray guifg=Gray
highlight markdownTaskP1Done ctermfg=Gray guifg=Gray
highlight markdownTaskP2Done ctermfg=Gray guifg=Gray

" Dim all completed tasks without priority labels
" This matches tasks that don't have P0, P1, or P2 patterns
syntax match markdownTaskDoneGeneral /^\s*- \[x\] \(P[012]\s\)\@!.*$/
highlight markdownTaskDoneGeneral ctermfg=Gray guifg=Gray

" Wikilink highlighting - only the content between [[ and ]]
" \zs and \ze mark the start/end of match to exclude brackets from styling
syn match WikiLink '\[\[\zs.\{-}\ze\]\]' containedin=ALL
hi def link WikiLink markdownUrl
