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
if !exists('*ReloadVimrc')
  function! ReloadVimrc()
      source $MYVIMRC
      if has('gui_running')
          source ~/.gvimrc
      endif
      " Re-trigger filetype detection to reload ftplugin files
      " This ensures buffer-specific settings (like shiftwidth for markdown) are reloaded
      filetype detect
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
    let save_cursor = getpos('.')
    " https://vi.stackexchange.com/questions/5949/substitute-with-pure-vimscript-without-s
    silent! keeppatterns %s/\s\+$//e
    call setpos('.', save_cursor)
endfunction
command! -range=% StripTrailingWhitespaces call StripTrailingWhitespaces()

" Trim end lines
function! TrimEndLines()
    let save_cursor = getpos('.')
    silent! keeppatterns %s#\($\n\s*\)\+\%$##
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
function! SQLListify() range
    execute a:firstline . ',' . a:lastline . "s/\\(\\S*\\)/'\\1',/g"
    execute a:lastline . 's/,$//'
endfunction
command! -range=% SQLListify call SQLListify()

" Format all uuids
function! FormatUUIDS()
    let save_cursor = getpos('.')
    silent! keeppatterns %s/\<
      \\([0-9A-Fa-f]\{8\}
      \\)\([0-9A-Fa-f]\{4\}\)
      \\([0-9A-Fa-f]\{4\}\)
      \\([0-9A-Fa-f]\{4\}\)
      \\([0-9A-Fa-f]\{12\}\)
      \\>
      \/\1-\2-\3-\4-\5
      \/g
    call setpos('.', save_cursor)
endfunction
command! FormatUUIDS call FormatUUIDS()

" Insert a uuid
function! InsertUUID()
    let cmd = 'uuidgen | tr "[:upper:]" "[:lower:]"'
    let result = substitute(system(cmd), '[\]\|[[:cntrl:]]', '', 'g')
    silent exec ':normal i' . result
endfunction
command! InsertUUID call InsertUUID()

" Replace with new uuid
function! ReplaceWithUUID()
    silent execute "normal! di\""
    call InsertUUID()
endfunction
command! ReplaceWithUUID call ReplaceWithUUID()

" Copy current filename (absolute path)
function! CopyCurrentFilenameAbs()
    let @*=expand('%:p')
endfunction
command! CopyCurrentFilenameAbs call CopyCurrentFilenameAbs()

" Copy current filename (relative path)
function! CopyCurrentFilename()
    let @*=expand('%')
endfunction
command! CopyCurrentFilename call CopyCurrentFilename()

" Continue a list properly
function! ContinueProseList()
    let l:line = getline('.')
    let l:list_marker = matchstr(l:line, '^\s*[-*]\s*')

    if !empty(l:list_marker)
        if l:line =~# '^\s*[-*]\s*$'
            " Empty list item: remove the marker and indent, then newline
            return "\<C-U>\<CR>"
        else
            " List item with content: continue the list at same indentation
            " Jump to column 0, then insert the marker with its captured indentation
            return "\<CR>\<C-O>0" . l:list_marker
        endif
    else
        " Not in a list: just newline
        return "\<CR>"
    endif
endfunction

function Scratch()
    execute 'tabnew '
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
endfunction
command! -nargs=0 Scratch call Scratch()

" Fix highlighting crashes
function RestartHighlight()
    execute 'syn off | syn on'
endfunction
command! RestartHighlight call RestartHighlight()


" Format with Python pprint
command! FormatJSONpprint %!python -c "
\import sys, json, pprint;
\try:
\    data = json.loads(sys.stdin.read());
\    pprint.pprint(data, width=120, indent=2, sort_dicts=True)
\except Exception as e:
\    print('JSON Error: ' + str(e), file=sys.stderr);
\    sys.exit(1)"

function! PrettyPrintJSONForgiving() range
    let content = join(getline(a:firstline, a:lastline), '')
    let result = ''
    let in_quotes = 0

    for i in range(len(content))
        let char = content[i]

        " Toggle quote state for both single and double quotes
        if (char == '"' || char == "'") && (i == 0 || content[i-1] != '\')
            let in_quotes = !in_quotes
        endif

        " Add character to result
        let result .= char

        " Add newline after comma if not inside quotes
        if !in_quotes && char == ','
            let result .= "\n"
        endif
    endfor

    execute a:firstline . ',' . a:lastline . 'delete'
    call append(a:firstline - 1, split(result, "\n"))
endfunction
command! PrettyJSONForgiving call PrettyPrintJSONForgiving()

function! PrettyPrintJSON() range
  let l:save_cursor = getcurpos()

  " Determine if we're in visual mode (range was specified)
  if a:firstline != a:lastline || (a:firstline == a:lastline && mode() =~# '[vV]')
    let l:start_line = a:firstline
    let l:end_line = a:lastline

    execute l:start_line . ',' . l:end_line . '!jq .'
  else
    execute '%!jq .'
  endif

  call setpos('.', l:save_cursor)
endfunction
command! -range=% PrettyJSON call PrettyPrintJSON()

function! PrettyPrintJSONJQ() range
  let l:save_cursor = getcurpos()

  " Determine if we're in visual mode (range was specified)
  if a:firstline != a:lastline || (a:firstline == a:lastline && mode() =~# '[vV]')
    let l:start_line = a:firstline
    let l:end_line = a:lastline

    execute l:start_line . ',' . l:end_line . '!jq .'
  else
    execute '%!jq .'
  endif

  call setpos('.', l:save_cursor)
endfunction
command! JSONPretty call PrettyPrintJSONJQ()

" Format SQL using sql-formatter
" Install with: npm install -g sql-formatter
function! FormatSQL() range
  let l:save_cursor = getcurpos()

  " Determine if we're in visual mode (range was specified)
  if a:firstline != a:lastline || (a:firstline == a:lastline && mode() =~# '[vV]')
    let l:start_line = a:firstline
    let l:end_line = a:lastline

    execute l:start_line . ',' . l:end_line . '!sql-formatter'
  else
    execute '%!sql-formatter'
  endif

  call setpos('.', l:save_cursor)
endfunction
command! -range=% FormatSQL call FormatSQL()
