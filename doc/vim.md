<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Vim](#vim)
  - [Tags](#tags)
  - [Troubleshooting](#troubleshooting)
    - [[vim-hug-neovim-rpc] requires one of `:pythonx import [pynvim|neovim]` command to work Deoplete Vim](#vim-hug-neovim-rpc-requires-one-of-pythonx-import-pynvimneovim-command-to-work-deoplete-vim)
  - [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Vim

## Tags

Source: https://vim.fandom.com/wiki/Browsing_programs_with_tags

Check tags configuration in `ctags/ctags`.

- Go to tag: `Ctrl-]`
- Preview a tag: `Ctrl-W }`
- Return after a tag jump: `Ctrl-[`, `:pop`

## Troubleshooting

### [vim-hug-neovim-rpc] requires one of `:pythonx import [pynvim|neovim]` command to work Deoplete Vim

Identify Python version used by vim by:

```
:pythonx import sys; print(sys.path)
```

Then use it to reinstall `pynvim`:

```bash
/usr/local/Cellar/python@3.10/3.10.2/bin/pip3 install pynvim
```

## References

- [A Vim Guide for Advanced Users](https://thevaluable.dev/vim-advanced/)
