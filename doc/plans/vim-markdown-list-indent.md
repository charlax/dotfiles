# Vim Markdown List Indent

## Goal

Smart list continuation in Markdown: pressing Enter on an empty list item removes the bullet and indent (standard text editor behavior).

## Solution

### Files Modified

**1. vim/my_functions.vim:127-143** - Fixed `ContinueProseList()` function
- Changed to use `"\<CR>\<C-O>0"` instead of `"\<CR>\<C-U>"`
- `<C-O>0` jumps to column 0 without interfering with the newline (unlike `<C-U>` which was canceling the `<CR>`)

**2. vim/ftplugin/markdown.vim:53** - Disabled vim-markdown auto-indent
- Set `g:vim_markdown_new_list_item_indent = 0`

**3. vim/after/ftplugin/markdown.vim:15-18** - Added Enter mapping
- `inoremap <buffer> <expr> <CR> ContinueProseList()`
- Set `formatoptions+=o` for normal mode `o`/`O`

**4. vim/after/indent/markdown.vim** - NEW FILE - Override plugin formatoptions
- `setlocal formatoptions-=r` to prevent double bullet insertion

### Why after/indent/?

Vim plugin loading order:
1. ftplugin/
2. indent/ ← vim-markdown sets `formatoptions+=r` here
3. after/ftplugin/
4. after/indent/ ← loads LAST, so our override sticks

### Behavior

- `- item` + Enter → `- ` (continues list)
- `- ` + Enter → removes bullet and indent
- Normal line + Enter → normal behavior
- `o`/`O` in normal mode → still auto-continues lists
