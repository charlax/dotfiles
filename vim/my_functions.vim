" Prefix lines
command! -range=% -bar Prepend <line1>,<line2>call PrefixLines()
function! PrefixLines() range
    call inputsave()
    let t = input('Prefix: ')
    call inputrestore()
    exe a:firstline . ',' . a:lastline . 's/^/\=t'
endfunction

" Set working directory to the current file
command! CdToCurrentFile cd %:p:h

" Reload vimrc
if !exists("*ReloadVimrc")
  function ReloadVimrc()
      source $MYVIMRC
      if has("gui_running")
          source ~/.gvimrc
      endif
  endfunction
  command! ReloadVimConfig call ReloadVimrc()
endif

" FocusMode
function! ToggleFocusMode()
    if (&foldcolumn != 12)
        set laststatus=0
        set numberwidth=10
        set foldcolumn=12
        set noruler
        hi FoldColumn ctermbg=none
        hi LineNr ctermfg=0 ctermbg=none
        hi NonText ctermfg=0
    else
        set laststatus=2
        set numberwidth=4
        set foldcolumn=0
        set ruler
        execute 'colorscheme ' . g:colors_name
    endif
endfunction
nnoremap <leader>V  :call ToggleFocusMode()<cr>

" Remove trailing whitespaces
function! StripTrailingWhitespaces()
    let save_cursor = getpos(".")
    %s/\s\+$//e
    call setpos('.', save_cursor)
endfunction
command! -range=% StripTrailingWhitespaces call StripTrailingWhitespaces()

" Trim end lines
function! TrimEndLines()
    let save_cursor = getpos(".")
    :silent! %s#\($\n\s*\)\+\%$##
    call setpos('.', save_cursor)
endfunction

function! EnableDisplayWrapping()
  if !&wrap
    setlocal wrap
    nnoremap j gj
    nnoremap k gk
  endif
endfunction

function! DisableDisplayWrapping()
  if &wrap
    setlocal nowrap
    nunmap <buffer> j
    nunmap <buffer> k
  endif
endfunction

" Wrap in '' and add trailing comma
function! SQLListify()
    %s/\(\S*\)/'\1',/g
    $s/,$/
endfunction
command! SQLListify call SQLListify()

" Format all uuids
function! FormatUUIDS()
    %s/\<
      \\([0-9A-Fa-f]\{8\}
      \\)\([0-9A-Fa-f]\{4\}\)
      \\([0-9A-Fa-f]\{4\}\)
      \\([0-9A-Fa-f]\{4\}\)
      \\([0-9A-Fa-f]\{12\}\)
      \\>
      \/\1-\2-\3-\4-\5
      \/g
endfunction
command! FormatUUIDS call FormatUUIDS()

" Insert a uuid
function! InsertUUID()
    let cmd = 'uuidgen | tr "[:upper:]" "[:lower:]"'
    let result = substitute(system(cmd), '[\]\|[[:cntrl:]]', '', 'g')
    silent exec ":normal i" . result
endfunction
command! InsertUUID call InsertUUID()

" Replace with new uuid
function! ReplaceWithUUID()
    silent execute "normal! di\""
    call InsertUUID()
endfunction
command! ReplaceWithUUID call ReplaceWithUUID()
