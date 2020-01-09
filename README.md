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

# Prerequisites

## Mac Os X

See fresh install below.

## Linux Debian

```bash
sudo apt update
sudo apt upgrade
sudo apt install git
```

# Installation

```bash
DOTFILES="$HOME/.dotfiles"
git clone https://github.com/charlax/dotfiles.git $DOTFILES

# If you want only dotfiles
python3 $DOTFILES/install.py

# On a fresh install
python3 $DOTFILES/install.py --with-all
```

To install all the required software, run:

```bash
~/.dotfiles/install/install-apps-all.sh
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

## Mac Os X Settings

* Change the computer name
* Add French input source
* Set keyboard shortcuts
  * Set the change input source shortcuts

Other steps:

```bash
# Install local git settings
cp gitconfig.local.template ~/.gitconfig.local
```

## Apps to install

* Annotate (App Store)
* Be Focused (App Store)
* Docker (installed via brew cask)
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
* [Notion](https://www.notion.so/desktop)
* Numbers (App Store)
* Pages (App Store)
* Pixelmator (App Store)
* Spectacle (installed by the script)
* [Spotify](https://www.spotify.com/fr/download/mac)
* Studies (App Store)
* [TextExpander](https://textexpander.com/download/) (not anymore on the app store)
* Things (App Store)
* Time Out (App Store)
* VLC (installed by the script)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (better to install manually as it requires Max Os X permissions)
* Visual Studio Code (installed by the script)
* iA Writer (App Store)

Setup the following apps:

* Password application
* Backup application
* Chrome
* Spectacle (open then run OSX config script to link configuration files)
* Dropbox
* Evernote
* TextExpander
* Things cloud
* Printers
* Notion
* Set iTerm2's preference file folder (requires full sync)

# Features

* [fzf](https://github.com/junegunn/fzf): fuzzy file finder. To use it on the command line, prefix with `**`, then press tab. For instance: `vim **<TAB>`.
* [autojump](https://github.com/wting/autojump): a cd commands that learns
  about your favorite directories.

# Misc

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
