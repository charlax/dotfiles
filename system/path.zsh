#!/usr/bin/env bash

# Brew on Linux
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  # shellcheck disable=SC2046
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

export CODE_PATH="$HOME/CodePerso"
export FORK_PATH="$HOME/Forks"

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
