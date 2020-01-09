#!/usr/bin/env bash

export EDITOR="vim"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  export EDITOR_GUI="gvim"
else
  export EDITOR_GUI="mvim"
fi

SHELL=$(command -v zsh)
export SHELL
export TERM=xterm-256color

[[ -e /usr/local/opt/autoenv/activate.sh ]] && source /usr/local/opt/autoenv/activate.sh

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
