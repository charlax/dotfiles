Installation
============

    $ curl -O https://raw.githubusercontent.com/charlax/dotfiles/master/install.py
    $ python install.py # If you want only dotfiles
    $ python install.py --with-dotvim # If you want also my dotvim

You should read the script before executing it.

Prerequisites
=============

Tested on Mac Os X 10.8, 10.10 and Ubuntu 12.04.

On Mac Os X: you'll need [Homebrew](http://mxcl.github.com/homebrew/) to
install some software.

You'll also need [Solarized](http://ethanschoonover.com/solarized)'s custom
palettes for iTerm.

Plugins
=======

Adding a ZSH plugin
-------------------

    $ git submodule add https://github.com/... zsh/plugins/plugin-name

Then add the description in the README.

Misc
====

* Keyboard shortcuts to [lock the screen](http://hints.macworld.com/article.php?story=20090831093941225).
* Installing my [vim dotfiles](https://github.com/charlax/dotvim) is available
  through the `install_vim_dotfiles.sh` command.
* You can copy the dotfiles to another folder with this command:
  ``rsync -vv -r --exclude='.git' --filter="dir-merge,- .gitignore" ~/.dotfiles/ new_path``
* [entr](https://bitbucket.org/eradman/entr/) is used to run arbitrary commands when files
  are changed.

List of software
================

    $ brew cask install mactex

Other tools to install:

* Brew
* Calibre
* Chrome
* Chrome Canary
* Crashplan
* Cyberduck
* Disk Inventory X
* Dropbox
* Evernote
* Firefox
* Flux
* Kindle
* LibreOffice
* MPEG Streamclip
* Mental Case
* Pomodoro
* Skype
* Spotify
* TeX
* TextWrangler (I use Vim but just in case)
* Things
* VLC
* Virtual Box
* Wireshark
* XCode
* iTerm2

Acknowledgments
===============

* [holman](https://github.com/holman/dotfiles)
