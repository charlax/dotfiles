<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Vim](#vim)
  - [Tags](#tags)
  - [Troubleshooting](#troubleshooting)
    - [jedi: jedi module is not found](#jedi-jedi-module-is-not-found)
    - [Deoplete yarp failed establishing channel for python3](#deoplete-yarp-failed-establishing-channel-for-python3)
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

### jedi: jedi module is not found

```text
"install.py" 287L, 8284B
[deoplete] jedi module is not found.  You need to install it.  Use :messages / see above for error details.
```

I just needed to run:

```bash
python3 -m pip install --upgrade --user jedi
```

### Deoplete yarp failed establishing channel for python3

```text
[deoplete] [yarp] [deoplete] job is dead. failed establishing channel for ['python3', '-u', '/Users/REDACTED/.dotfiles/vim/plugged/nvim-yarp/pythonx/yarp.py', 'redacted', 2, 'deoplete']
[deoplete] VimEnter Autocommands for "*"..function deoplete#enable[9]..deoplete#initialize[1]..deoplete#init#_initialize[15]..deoplete#init#_channel[24]..yarp#core#notify[1]..yarp#core#wait_channel, line 13
```

Just run the same command:

```bash
$ python3 -u /Users/REDACTED/.dotfiles/vim/plugged/nvim-yarp/pythonx/yarp.py REDACTED 2 deoplete
No version is set for command python3
Consider adding one of the following versions in your config file at /Users/ca/.tool-versions
python 3.11.0
```

Issue is coming from [asdf](https://asdf-vm.com). I modified `~/.tool-versions` to add:

```text
python system
```

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
