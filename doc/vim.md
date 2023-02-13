<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Vim](#vim)
  - [Tags](#tags)
  - [Troubleshooting](#troubleshooting)
    - [jedi: jedi module is not found](#jedi-jedi-module-is-not-found)
    - [Check Python version used by Vim](#check-python-version-used-by-vim)
    - [E370: Could not load library Python](#e370-could-not-load-library-python)
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

### jedi: jedi module is not found

```text
"install.py" 287L, 8284B
```

I just needed to run:

```bash
python3 -m pip install --upgrade --user jedi
```

### Check Python version used by Vim

Identify Python version used by vim by:

```
:pythonx import sys; print(sys.path); print(sys.version)
```

To execute from the command line:

```bash
vim -c ':set t_ti= t_te= nomore' "+pythonx import sys; print(sys.path)" +qall
```

### E370: Could not load library Python

Full message:

```text
/usr/local/Frameworks/Python.framework/Versions/3.10/Python: dlopen(/usr/local/Frameworks/Python.framework/Versions/3.10/Python, 0x0009): tried: '/usr/local/Frameworks/Python.framework/Versions/3.10/Python' (no such file)
```

Check if the folder pointed at `:set pythonthreedll` exists. If not, this might be because of a mismatch between the Python version MacVim was compiled with, and the installed one. Installing the Homebrew formula (as opposed to installing the Cask) fixed this.

## References

- [A Vim Guide for Advanced Users](https://thevaluable.dev/vim-advanced/)
