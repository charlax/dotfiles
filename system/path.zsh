#!/usr/bin/env bash

if [[ "$_PATH_SOURCED" = 1 ]]; then
    return 0
fi
export _PATH_SOURCED=1

# Brew on Linux
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  # shellcheck disable=SC2046
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# Brew on Apple Silicon
if [[ -e /opt/homebrew/bin ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi

# Google Cloud
if command -v brew &>/dev/null; then
    _gcloud_inc="$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
    # shellcheck disable=SC1090
    [[ -e "$_gcloud_inc" ]] && source "$_gcloud_inc"
    unset _gcloud_inc
fi

export CODE_PATH="$HOME/CodePerso"
export FORK_PATH="$HOME/Forks"

# Go
export GOPATH=$CODE_PATH/golang

# GNU binaries (e.g., gtar on macos)
[[ -e /opt/homebrew/opt/gnu-tar/libexec/gnubin ]] && export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"

# Java
JAVA_HOME=$(/usr/libexec/java_home -v 1.8) >/dev/null 2>&1
export JAVA_HOME

# Python
PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"

# Latex
[[ -e /usr/texbin ]] && export PATH="/usr/texbin:$PATH"
[[ -e $HOME/.cargo/bin ]] && export PATH="$HOME/.cargo/bin:$PATH"

# $HOME/.local/bin is necessary for uvx (among others)
export PATH="/usr/local/opt/gettext/bin:/usr/local/bin:/usr/local/sbin:$ZSH/bin:$PATH:$HOME/bin:$GOPATH/bin:$PYTHON_BIN_PATH:$HOME/.local/bin"

export MANPATH="/usr/local/man:/usr/local/git/man:$MANPATH"

# Dotfiles
export DOTFILES="$HOME/.dotfiles"
export VIM_DOTFILES="$DOTFILES/vim"

export CHEAT_CONFIG_PATH="$DOTFILES/config/cheat/conf.yml"
