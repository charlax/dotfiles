set guifont=Menlo:h12
set antialias
set linespace=2

" Show cursor line
set cursorline

" Changing the color for invisible characters
hi NonText guifg=#c0c0c0 guibg=NONE
hi SpecialKey guifg=#c0c0c0 guibg=NONE

macm Window.Select\ Previous\ Tab  key=<D-A-Left>
macm Window.Select\ Next\ Tab    key=<D-A-Right>

" Don't beep
set visualbell

" Start without the toolbar
set guioptions-=T

" Change tab label to tab number, filename with parent directory, modified
function! GuiTabLabel()
     return expand('%:p:.')
endfunction
set guitablabel=%N.\ %{GuiTabLabel()}%m

if has("gui_macvim")
    " Fullscreen takes up entire screen
    set fuoptions=maxhorz,maxvert
    macmenu &Tools.Make key=<nop>

    " Cmd+S save and goes to normal mode
    macmenu &File.Save key=<nop>
    inoremap <D-s> <ESC>:w<CR>
    nnoremap <D-s> :w<CR>
end

" Keep undo history across sessions, by storing in file.
" Only works in MacVim (gui) mode.
set undodir=~/.vim/backups
set undofile
