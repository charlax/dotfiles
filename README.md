<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Installation](#installation)
- [Prerequisites](#prerequisites)
- [Features](#features)
- [Plugins](#plugins)
  - [Adding a ZSH plugin](#adding-a-zsh-plugin)
- [Misc](#misc)
  - [Profiling ZSH](#profiling-zsh)
- [List of software](#list-of-software)
  - [Useful software (not installed by default)](#useful-software-not-installed-by-default)
- [Acknowledgments](#acknowledgments)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Installation
============

    $ curl -O https://raw.githubusercontent.com/charlax/dotfiles/master/install.py
    $ python install.py # If you want only dotfiles
    $ python install.py --with-dotvim # If you want also my dotvim

You should read the script before executing it.

You'll also need to:

* Create `git/gitconfig.local` with your username and name.

Prerequisites
=============

Tested on Mac Os X 10.8, 10.10 and Ubuntu 12.04.

On Mac Os X: you'll need [Homebrew](http://mxcl.github.com/homebrew/) to
install some software.

You'll also need [Solarized](http://ethanschoonover.com/solarized)'s custom
palettes for iTerm.

Features
========

* [fzf](https://github.com/junegunn/fzf): fuzzy file finder. To use it on the
  command line, prefix with `**`, then press tab. For instance: `vim **<TAB>`.
* [autojump](https://github.com/wting/autojump): a cd commands that learns
  about your favorite directories.

Plugins
=======

Adding a ZSH plugin
-------------------

    $ git submodule add https://github.com/... zsh/plugins/plugin-name

Then add the description in the README.

Misc
====

* Keyboard shortcuts to [lock the
  screen](http://hints.macworld.com/article.php?story=20090831093941225).
* Installing my [vim dotfiles](https://github.com/charlax/dotvim) is available
  through the `install_vim_dotfiles.sh` command.
* You can copy the dotfiles in the current directory through
  `copy-dotfiles-here.sh`
* [entr](https://bitbucket.org/eradman/entr/) is used to run arbitrary commands
  when files are changed.

Profiling ZSH
-------------

Use `zprof`:

```
# At the beginning of your file, e.g. zshrc
zmodload zsh/zprof

...

# At the end:
zprof
```

List of software
================

Install brew, then run `install/osx_software_install.sh`. This will install, in
particular:

* `tldr`, which is a community-maintained summary of manual pages. Example
  usage: `tldr tar`.

Can be useful:

* Disk Inventory X
* MPEG Streamclip
* Virtual Box
* Wireshark

From App Store:

* XCode
* Kindle
* Mental Case
* TextWrangler (I use Vim but just in case)

Manually:

* Firefox (as of writing, does not work with some apps)
* Spotify
* Things
* TextExpander (not anymore on the app store)

Useful software (not installed by default)
------------------------------------------

* [Numi](https://numi.io/): beautiful calculator app for Mac (like Soulver)

Acknowledgments
===============

* [holman](https://github.com/holman/dotfiles)
