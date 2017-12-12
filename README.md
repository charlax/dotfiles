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

Prerequisites
=============

On Mac Os X: you'll need [Homebrew](http://mxcl.github.com/homebrew/) to
install some software. As of writing, to install it you just need:

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Installation
============

    $ cd ~/Downloads
    $ curl -O https://raw.githubusercontent.com/charlax/dotfiles/master/install.py
    $ python install.py # If you want only dotfiles
    $ python install.py --with-dotvim # If you want also my dotvim

You should read the script before executing it.

Software install
----------------

To install some extra software, run the following:

    $ ./install/osx_install.sh
    $ ./install/osx_app_install.sh

This will install, in particular:

* `tldr`, which is a community-maintained summary of manual pages. Example
  usage: `tldr tar`.

Setting the default shell to ZSH
--------------------------------

Go to the `Users & Groups` pane of the System Preferences, unlock it, right
click on the user and set the shell to the output of `which zsh`.

Features
========

* [fzf](https://github.com/junegunn/fzf): fuzzy file finder. To use it on the
  command line, prefix with `**`, then press tab. For instance: `vim **<TAB>`.
* [autojump](https://github.com/wting/autojump): a cd commands that learns
  about your favorite directories.

Misc
====

* Installing my [vim dotfiles](https://github.com/charlax/dotvim) is available
  through the `install_vim_dotfiles.sh` command.
* You can copy the dotfiles in the current directory through
  `copy-dotfiles-here.sh`

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

List of software to install manually
====================================

Can be useful:

* Disk Inventory X
* MPEG Streamclip
* Virtual Box
* Wireshark

From App Store, among others:

* XCode
* Things
* Kindle
* TextWrangler (I use Vim but just in case)

Manually:

* Spotify
* TextExpander (not anymore on the app store)
* Dropbox

Useful software (not installed by default)
------------------------------------------

* [Numi](https://numi.io/): beautiful calculator app for Mac (like Soulver)

Acknowledgments
===============

* [holman](https://github.com/holman/dotfiles)
