#!/usr/bin/env bash

# Brew on Linux
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# shellcheck source=/dev/null
[[ -s $(brew --prefix 2> /dev/null)/etc/autojump.sh ]] && . "$(brew --prefix)"/etc/autojump.sh
[[ -s /usr/share/autojump/autojump.sh ]] && . /usr/share/autojump/autojump.sh

dropbox_config=$HOME/.dropbox/info.json
if [[ -e $dropbox_config ]]; then
    DROPBOX_FOLDER=$(python -c 'import json,sys;obj=json.load(sys.stdin);print(obj["personal"]["path"])' < "$dropbox_config")
    export DROPBOX_FOLDER
fi

export CODE_PATH="$HOME/Documents/Code"
export FORK_PATH="$HOME/Documents/code_forks"
# Override if Dropbox is there
[[ -n ${DROPBOX_FOLDER+x} ]] && export CODE_PATH="$DROPBOX_FOLDER/Code"
[[ -n ${DROPBOX_FOLDER+x} ]] && export FORK_PATH="$DROPBOX_FOLDER/code_forks"

# Go
export GOPATH=$CODE_PATH/golang

# Java
JAVA_HOME=$(/usr/libexec/java_home -v 1.8) >/dev/null 2>&1
export JAVA_HOME

# Python
PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"

# Latex
[[ -e /usr/texbin ]] && export PATH="/usr/texbin:$PATH"

# $HOME/.local/bin is necessary for pipx (among others)
export PATH="/usr/local/opt/gettext/bin:/usr/local/bin:/usr/local/sbin:$ZSH/bin:$PATH:$HOME/bin:$GOPATH/bin:$PYTHON_BIN_PATH:$HOME/.local/bin"

export MANPATH="/usr/local/man:/usr/local/git/man:$MANPATH"

# Dotfiles
export DOTFILES="$HOME/.dotfiles"
export VIM_DOTFILES="$DOTFILES/vim"

export CHEAT_CONFIG_PATH="$DOTFILES/config/cheat/conf.yml"
