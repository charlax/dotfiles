" Fuzzy file completion source for asyncomplete
" Improved version with fuzzy matching support

function! s:fuzzy_match_score(str, pattern) abort
  " Calculate fuzzy match score
  " Returns -1 if no match, otherwise returns a score (lower is better)
  let l:str_lower = tolower(a:str)
  let l:pattern_lower = tolower(a:pattern)

  if empty(a:pattern)
    return 0
  endif

  let l:score = 0
  let l:str_idx = 0
  let l:pattern_idx = 0
  let l:last_match_idx = -1

  while l:pattern_idx < len(l:pattern_lower)
    let l:pattern_char = l:pattern_lower[l:pattern_idx]
    let l:found = 0

    while l:str_idx < len(l:str_lower)
      if l:str_lower[l:str_idx] ==# l:pattern_char
        " Bonus for consecutive matches
        if l:last_match_idx >= 0 && l:str_idx == l:last_match_idx + 1
          let l:score += 1
        else
          let l:score += 5
        endif

        " Bonus for matching at word boundaries
        if l:str_idx == 0 || a:str[l:str_idx - 1] =~# '[_\-/.]'
          let l:score -= 2
        endif

        let l:last_match_idx = l:str_idx
        let l:str_idx += 1
        let l:found = 1
        break
      endif
      let l:str_idx += 1
    endwhile

    if !l:found
      return -1
    endif

    let l:pattern_idx += 1
  endwhile

  return l:score
endfunction

function! s:format_match(file, prefix, pattern) abort
  let l:basename = fnamemodify(a:file, ':t')
  let l:is_dir = isdirectory(a:file)

  " Calculate the word to insert
  if empty(a:prefix) || a:prefix ==# '.'
    let l:word = l:basename
  else
    let l:word = a:prefix . l:basename
  endif

  " Format abbreviation
  let l:abbr = l:basename
  if l:is_dir
    let l:abbr = l:abbr . '/'
  endif

  " Calculate fuzzy match score
  let l:score = s:fuzzy_match_score(l:basename, a:pattern)

  return {
    \ 'word': l:word,
    \ 'abbr': l:abbr,
    \ 'menu': l:is_dir ? '[dir]' : '[file]',
    \ 'dup': 1,
    \ 'icase': 1,
    \ 'user_data': {
    \   'is_dir': l:is_dir,
    \   'score': l:score
    \ }
    \ }
endfunction

function! s:sort_matches(m1, m2) abort
  let l:d1 = get(get(a:m1, 'user_data', {}), 'is_dir', 0)
  let l:d2 = get(get(a:m2, 'user_data', {}), 'is_dir', 0)

  " Directories first
  if l:d1 && !l:d2
    return -1
  elseif !l:d1 && l:d2
    return 1
  endif

  " Then by fuzzy match score
  let l:s1 = get(get(a:m1, 'user_data', {}), 'score', 999)
  let l:s2 = get(get(a:m2, 'user_data', {}), 'score', 999)

  if l:s1 < l:s2
    return -1
  elseif l:s1 > l:s2
    return 1
  endif

  " Finally alphabetically
  return a:m1.abbr ==# a:m2.abbr ? 0 : a:m1.abbr > a:m2.abbr ? 1 : -1
endfunction

function! asyncomplete#sources#fuzzyfile#completor(opt, ctx) abort
  let l:bufnr = a:ctx['bufnr']
  let l:typed = a:ctx['typed']
  let l:col = a:ctx['col']

  " Match file path patterns
  " Supports: /path, ./path, ../path, ~/path, and relative paths
  let l:kw = matchstr(l:typed, '\(\~\|/\|\./\|\.\./\|\.\.\./\)[^ \t]*$')

  " Also match simple filenames in current directory
  if empty(l:kw)
    let l:kw = matchstr(l:typed, '\f\+$')
    " Only proceed if it looks like a file path (contains / or .)
    if l:kw !~# '[/.]'
      return
    endif
  endif

  let l:kwlen = len(l:kw)

  if l:kwlen < 1
    return
  endif

  " Determine the directory to search
  let l:dir = fnamemodify(l:kw, ':h')
  let l:partial = fnamemodify(l:kw, ':t')

  " Resolve directory path and preserve user's prefix
  if l:kw =~# '^/'
    " Absolute path
    let l:search_dir = l:dir ==# '/' ? '/' : l:dir
    let l:prefix = l:dir ==# '/' ? '/' : l:dir . '/'
  elseif l:kw =~# '^\~'
    " Home directory
    let l:expanded = expand(l:dir)
    let l:search_dir = l:expanded
    let l:prefix = l:dir . '/'
  elseif l:kw =~# '^\.\.'
    " Parent directory (../ or ../../)
    let l:buf_dir = expand('#' . l:bufnr . ':p:h')
    let l:search_dir = l:buf_dir . '/' . l:dir
    let l:prefix = l:dir . '/'
  elseif l:kw =~# '^\.\/'
    " Explicit current directory (./)
    let l:buf_dir = expand('#' . l:bufnr . ':p:h')
    let l:search_dir = l:dir ==# '.' ? l:buf_dir : l:buf_dir . '/' . l:dir
    let l:prefix = l:dir ==# '.' ? './' : l:dir . '/'
  elseif l:dir ==# '.' || empty(l:dir)
    " Implicit current directory (no prefix)
    let l:buf_dir = expand('#' . l:bufnr . ':p:h')
    let l:search_dir = l:buf_dir
    let l:prefix = ''
  else
    " Relative path (subdirs/)
    let l:buf_dir = expand('#' . l:bufnr . ':p:h')
    let l:search_dir = l:buf_dir . '/' . l:dir
    let l:prefix = l:dir . '/'
  endif

  " Normalize prefix
  if l:prefix =~# '//$'
    let l:prefix = substitute(l:prefix, '/\+$', '/', '')
  endif

  if !empty(l:prefix) && l:prefix !~# '/$'
    let l:prefix = l:prefix . '/'
  endif

  " Get all files in directory (including hidden files)
  let l:glob_pattern = l:search_dir . '/*'
  let l:files = glob(l:glob_pattern, 0, 1)

  " Also get hidden files (starting with .)
  let l:hidden_pattern = l:search_dir . '/.[^.]*'
  let l:hidden_files = glob(l:hidden_pattern, 0, 1)
  let l:files = l:files + l:hidden_files

  " Filter and score matches
  let l:matches = []
  for l:file in l:files
    let l:basename = fnamemodify(l:file, ':t')
    let l:score = s:fuzzy_match_score(l:basename, l:partial)

    " Only include if fuzzy match succeeds or no pattern
    if l:score >= 0 || empty(l:partial)
      let l:match = s:format_match(l:file, l:prefix, l:partial)
      call add(l:matches, l:match)
    endif
  endfor

  " Sort matches
  let l:matches = sort(l:matches, function('s:sort_matches'))

  let l:startcol = l:col - l:kwlen
  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches)
endfunction

function! asyncomplete#sources#fuzzyfile#get_source_options(opts) abort
  return extend(extend({}, a:opts), {
    \ 'triggers': {'*': ['/', '.']},
    \ 'priority': 10
    \ })
endfunction
