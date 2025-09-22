" Priority task highlighting for markdown files
" Define syntax patterns for priority tasks
syntax match markdownTaskP0 /^\s*- \[ \] P0\s.*$/ contains=markdownTaskP0Priority
syntax match markdownTaskP1 /^\s*- \[ \] P1\s.*$/ contains=markdownTaskP1Priority
syntax match markdownTaskP2 /^\s*- \[ \] P2\s.*$/ contains=markdownTaskP2Priority

" Define the priority labels themselves for more specific styling
syntax match markdownTaskP0Priority /P0/ contained
syntax match markdownTaskP1Priority /P1/ contained
syntax match markdownTaskP2Priority /P2/ contained

" Define highlight groups with the requested colors
highlight markdownTaskP0Priority ctermbg=Red ctermfg=White guibg=Red guifg=White
highlight markdownTaskP1Priority ctermfg=DarkYellow guifg=Orange
highlight markdownTaskP2Priority ctermfg=DarkGreen guifg=DarkGreen

" Highlight completed priority tasks differently
syntax match markdownTaskP0Done /^\s*- \[x\] P0\s.*$/ contains=markdownTaskP0DonePriority
syntax match markdownTaskP1Done /^\s*- \[x\] P1\s.*$/ contains=markdownTaskP1DonePriority
syntax match markdownTaskP2Done /^\s*- \[x\] P2\s.*$/ contains=markdownTaskP2DonePriority

syntax match markdownTaskP0DonePriority /P0/ contained
syntax match markdownTaskP1DonePriority /P1/ contained
syntax match markdownTaskP2DonePriority /P2/ contained

" Dimmed versions for completed tasks
highlight markdownTaskP0DonePriority ctermbg=DarkRed ctermfg=Gray guibg=DarkRed guifg=Gray
highlight markdownTaskP1DonePriority ctermbg=Brown ctermfg=Gray guibg=#CC6600 guifg=Gray
highlight markdownTaskP2DonePriority ctermbg=DarkGreen ctermfg=Gray guibg=DarkGreen guifg=Gray
