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

```bash
cd ~/Downloads
curl -O https://raw.githubusercontent.com/charlax/dotfiles/master/install.py

# If you want only dotfiles
python3 install.py

# On a fresh install
python3 install.py --with-all

# If you want also my dotvim
python3 install.py --with-dotvim
```

You should read the script before executing it. By default, dotfiles are stored in `~/.dotfiles/`.

To install all the required software, run:

```bash
~/.dotfiles/install/install-apps-all.sh
```

# Prerequisites

## Mac Os X

See fresh install below.

## Linux Debian

```bash
apt-get update
apt-get install -y curl git
```

# Post-install checklist on a fresh installation - Mac Os X

## After factory reset

1. Install any OS upgrade
2. Install XCode from the App Store. Open it and accept the T&C.
3. Install [iTerm](https://iterm2.com/downloads.html)
4. Install [Homebrew](https://brew.sh/) (see above)
5. Run the steps below

```bash
# Install dependencies
brew install git python3

# Install ssh keys and verify you can connect to github:
ssh -T git@github.com

# Then, install dotfiles and run install.py
```

## Settings

* Change the computer name
* Add French input source
* Set keyboard shortcuts
  * Set the change input source shortcuts
* Change key repeat and delay until repeat
* Remove sound effects

Other steps:

```bash
# Install local git settings
cp gitconfig.local.template ~/.gitconfig.local
```

## Apps to install

* Annotate (App Store)
* Be Focused (App Store)
* Docker
* [Dropbox](https://www.dropbox.com/install)
* Evernote (App Store)
* Firefox (installed by the script)
* Google Chrome Canary (installed by the script)
* [Google Chrome](https://www.google.com/chrome/)
* Grammarly
* Keynote (App Store)
* Kindle (App Store)
* LibreOffice (installed by the script)
* MindNode (App Store)
* Notion
* Numbers (App Store)
* Pages (App Store)
* Pixelmator (App Store)
* Spectacle (installed by the script)
* [Spotify](https://www.spotify.com/fr/download/mac)
* Studies (App Store)
* TextExpander (not anymore on the app store)
* Things (App Store)
* Time Out (App Store)
* VLC (installed by the script)
* VirtualBox (better to install manually as it requires Max Os X permissions)
* Visual Studio Code
* iA Writer (App Store)

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

## Checklist before reinstall

* Backup SSH keys
* Check each app for backup
* Backup hidden files in repo
* Backup `/Library/`
* Backup `~/Library/`
* Make sure branches in repo are pushed
* Search for "what folders to backup"
* Search for "checklist before factory reset"
* Backup photos (too important)
* Make sure iCloud sync is finished (check status bar in Finder)
* What's most important? Is it backed up?

# Acknowledgments

* [holman](https://github.com/holman/dotfiles)
