" Fuzzy file completion source for asyncomplete (Lua backend)
" VimScript wrapper around Lua implementation for compatibility

function! asyncomplete#sources#fuzzyfile_lua#completor(opt, ctx) abort
  " Convert context to Lua-compatible format
  let l:ctx_lua = {
    \ 'bufnr': a:ctx['bufnr'],
    \ 'typed': a:ctx['typed'],
    \ 'col': a:ctx['col']
    \ }

  " Call Lua to compute matches and startcol
  let l:result = luaeval('require("asyncomplete.sources.fuzzyfile").completor(_A)', l:ctx_lua)

  " If we got results, call asyncomplete#complete
  if type(l:result) == type({}) && has_key(l:result, 'matches')
    call asyncomplete#complete(a:opt['name'], a:ctx, l:result['startcol'], l:result['matches'])
  endif
endfunction

function! asyncomplete#sources#fuzzyfile_lua#get_source_options(opts) abort
  return extend(extend({}, a:opts), {
    \ 'triggers': {'*': ['/', '.']},
    \ 'priority': 10
    \ })
endfunction
