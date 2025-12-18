scriptencoding utf-8

" Show all mappings:
" :map :nmap :vmap :imap

" Show all mappings including where they were defined:
" :verbose map

" To check if a key is used:
" :verbose map <key>
"
" E.g.
" :verbose map <c-j>

" Make `jj` and `jk` throw you into normal mode
inoremap jj <esc>
inoremap jk <esc>

" Fast saving
nmap <c-s> :w<cr>
nmap <leader>w :w<cr>
nmap <leader>s :w<cr>
nmap <leader>. :w<cr>
nmap zz :w<cr>
nmap <leader>m :wq<cr>

" Movement by screen line instead of file line
nnoremap j gj
nnoremap k gk

" Strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Comment out the selection
vnoremap // gc

" Re-hardwrap paragraphs of text
nnoremap <leader>q gqip

" Re-hardwrap but first separate from next line
nnoremap <leader>Q o<esc>kgqip

" Re-indent file, keeping cursor position
nmap <leader>= mzgg=G`z<CR>

" Reselect the text that was just pasted
nnoremap <leader>v V`]

" Easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Easier resizing
" nnoremap <Leader>j :exe "vertical resize " . (winheight(0) * 3/2)<CR>
" nnoremap <Leader>h :exe "vertical resize " . (winheight(0) * 2/3)<CR>

" fzf (mimicking some ctrlp mappings)
nmap ; :Ag<CR>
nmap <c-p> :Files<CR>
nmap <c-t> :Tags<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>T :Tags<CR>

" Open the tag definition in a new tab
nnoremap <leader>] :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" Open the tag definition in a vertical split (this is <A-]>).
nnoremap ‘ :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" To prefix lines
noremap <leader>i :s/^/\V

" Use :W! to write to a file using sudo if you forgot to 'sudo vim file'
cmap W! %!sudo tee > /dev/null %

" Preview file
nmap <Leader>P :Preview<CR>

" Open NERDTree
function! OpenNerdTree()
    if strlen(expand('%')) == 0
        exec(':NERDTreeToggle')
    else
        exec(':NERDTreeFind')
    endif
endfunction

map <Leader>p :call OpenNerdTree()<CR>

" Underline the current line with '='
nmap <silent> <leader>u1 :t.<CR>Vr=

" Underline the current line with '-'
nmap <silent> <leader>u2 :t.<CR>Vr-

" Underline the current line with '^'
nmap <silent> <leader>u3 :t.<CR>Vr^

" Underline the current line with '^'
nmap <silent> <leader>u4 :t.<CR>Vr"

" Reselect visual block after indent change
vnoremap < <gv
vnoremap > >gv

" Move lines up and down
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
vnoremap <leader>j :m '>+1<CR>gv=gv
vnoremap <leader>k :m '<-2<CR>gv=gv

" Highlight and copy as RTF
vnoremap <leader>h :RTFHighlight python<CR>

" Expand region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Remove highlighting after search
map <Leader>n :noh<CR>

" Copy filename to clipboard
nmap ,cs :let @*=expand("%")<CR>
nmap ,cl :let @*=expand("%:p")<CR>

" Copy into system clipboard
noremap <Leader>y "+y

" Prettify json
map <buffer> <leader>js <Esc>:%!jq .<CR>

" =======================================================
" Completion
" =======================================================

" https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE

" Use tab and shift-tab to go through options

" pumvisible() checks for whether the autocompletion modal is visible. If it
" is, tab will be used to move through the matches.

" use tab to forward cycle
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" use shift-tab to backward cycle
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" use enter to select an option
inoremap <silent><expr><CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" =======================================================
" /Completion
" =======================================================

" =======================================================
" LSP Keybindings
" =======================================================

" Go to definition
nmap <silent> gd <plug>(lsp-definition)
" F12 for definition (same as IDEA, VSCode, etc.)
nmap <silent> <F12> <plug>(lsp-definition)
" Go to type definition
nmap <silent> gy <plug>(lsp-type-definition)
" Go to implementation
nmap <silent> gi <plug>(lsp-implementation)
" Find references
nmap <silent> gr <plug>(lsp-references)
" Rename symbol
nmap <silent> <leader>rn <plug>(lsp-rename)
" Show hover documentation
nmap <silent> K <plug>(lsp-hover)
" Show signature help
inoremap <silent> <C-k> <C-o>:LspSignatureHelp<CR>
" Format document
nmap <silent> <leader>f <plug>(lsp-document-format)
vmap <silent> <leader>f <plug>(lsp-document-range-format)
" Show diagnostics
nmap <silent> <leader>d <plug>(lsp-document-diagnostics)
" Next/previous diagnostic
nmap <silent> [g <plug>(lsp-previous-diagnostic)
nmap <silent> ]g <plug>(lsp-next-diagnostic)
" Peek definition
nmap <silent> gp <plug>(lsp-peek-definition)

" =======================================================
" /LSP Keybindings
" =======================================================

" UltiSnips (for snippets, not for autocompletion)

" Tab/shift-tab can be used to select the snippet key.
" Then, c-y will trigger expand the snippet

" Do not use tab - we use for autocompletion
" Do not use leader - messes up with insertion mode
let g:UltiSnipsExpandTrigger='<c-y>'

map <C-up> :tabr<cr>
map <C-down> :tabl<cr>
map <C-left> :tabp<cr>
map <C-right> :tabn<cr>

" Tabs
if has('gui_macvim')
    " cmd + tab number jumps to tab
    " D maps to command key in MacVim
    noremap <D-1> 1gt
    noremap <D-2> 2gt
    noremap <D-3> 3gt
    noremap <D-4> 4gt
    noremap <D-5> 5gt
    noremap <D-6> 6gt
    noremap <D-7> 7gt
    noremap <D-8> 8gt
    noremap <D-9> 9gt
    noremap <D-0> :tablast<cr>
end

" Note: VimR and Neovim return false for has('gui_running')
if has('gui_vimr')
    nnoremap <D-A-Left> :tabp<CR>
    vnoremap <D-A-Left> :tabp<CR>
    inoremap <D-A-Left> <ESC>:tabp<CR>
    nnoremap <D-A-Right> :tabn<CR>
    vnoremap <D-A-Right> :tabn<CR>
    inoremap <D-A-Right> <ESC>:tabn<CR>
endif

" I never use Ex mode, and it conflicts with my keyboard habits with French
" layout
noremap Q A

" Fugitive Conflict Resolution
nnoremap <leader>gd :Gdiffsplit!<CR>
" gd h -> use left (h key in Vim)
nnoremap gdh :diffget //2<CR>
" gd h -> use right (l key in Vim)
nnoremap gdl :diffget //3<CR>
