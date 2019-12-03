<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Installation](#installation)
- [Prerequisites](#prerequisites)
  - [Mac Os X](#mac-os-x)
    - [XCode](#xcode)
    - [Homebrew](#homebrew)
  - [Linux Debian](#linux-debian)
- [Post-install checklist on a fresh installation](#post-install-checklist-on-a-fresh-installation)
  - [Settings](#settings)
  - [Apps to install](#apps-to-install)
- [Features](#features)
- [Misc](#misc)
  - [Profiling ZSH](#profiling-zsh)
  - [Useful software (not installed by default)](#useful-software-not-installed-by-default)
  - [Manual backup before reinstall](#manual-backup-before-reinstall)
- [Acknowledgments](#acknowledgments)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Installation

    $ cd ~/Downloads
    $ curl -O https://raw.githubusercontent.com/charlax/dotfiles/master/install.py
    $ python3 install.py # If you want only dotfiles
    $ python3 install.py --with-dotvim # If you want also my dotvim

You should read the script before executing it. By default, dotfiles are stored in `~/.dotfiles/`.

To install all the required software, run:

    $ ~/.dotfiles/install/install-apps-all.sh

# Prerequisites

## Mac Os X

### XCode

Install XCode, then open it. Run this as well:

    $ xcode-select --install

### Homebrew

On Mac Os X: you'll need [Homebrew](http://mxcl.github.com/homebrew/) to install some software. As of writing, to install it you just need:

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

On a fresh installation, you might also need to setup your Github SSH keys. You can test them with:

    $ ssh -T git@github.com

## Linux Debian

    $ apt-get update
    $ apt-get install -y curl git

# Post-install checklist on a fresh installation

## Settings

* Change the computer name
* Add French input source
* Set keyboard shortcuts
  * Set the change input source shortcuts
* Change key repeat and delay until repeat
* Remove sound effects

## Apps to install

* Alfred
* Annotate
* Be Focused
* Docker
* Dropbox
* Evernote
* Firefox
* Google Chrome Canary
* Google Chrome
* Grammarly
* Keynote
* Kindle
* LibreOffice
* MindNode
* Notion
* Numbers
* Pages
* Pixelmator
* Spectacle
* Spotify
* Studies
* TextExpander (not anymore on the app store)
* Things
* Time Out
* VLC
* VirtualBox (better to install manually as it requires Max Os X permissions)
* Visual Studio Code
* iA Writer
* iTerm

Setup the following apps:

* Password application
* Backup application
* Chrome
* Spectacle (open at login)
* Dropbox
* Evernote
* TestExpander
* Things cloud
* Printers
* Set iTerm2's preference file folder (they include setting ZSH as the default
  shell)
* Set Alfred's preference file folder

# Features

* [fzf](https://github.com/junegunn/fzf): fuzzy file finder. To use it on the command line, prefix with `**`, then press tab. For instance: `vim **<TAB>`.
* [autojump](https://github.com/wting/autojump): a cd commands that learns
  about your favorite directories.

# Misc

* Installing my [vim dotfiles](https://github.com/charlax/dotvim) is available through the `install-vim-dotfiles.sh` command.
* You can copy the dotfiles in the current directory through
  `copy-dotfiles-here.sh`

## Profiling ZSH

Use `zprof`:

```
# At the beginning of your file, e.g. zshrc
zmodload zsh/zprof

...

# At the end:
zprof
```

## Useful software (not installed by default)

* [Numi](https://numi.io/): beautiful calculator app for Mac (like Soulver)

## Manual backup before reinstall checklist

* SSH keys
* Check each app
* Hidden files in repo
* `/Library/`
* `~/Library/`
* Make sure branches in repo are pushed
* Google "what folders to backup"
* What's most important? Is it backed up?

# Acknowledgments

* [holman](https://github.com/holman/dotfiles)
