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

# shellcheck disable=SC1091
[[ -e /usr/local/opt/autoenv/activate.sh ]] && source /usr/local/opt/autoenv/activate.sh

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# For bat (improved cat)
export BAT_THEME="Solarized (light)"

# OpenJDK 64-Bit Server VM warning: Options -Xverify:none and -noverify
# were deprecated in JDK 13 and will likely be removed in a future release.
# https://github.com/technomancy/leiningen/issues/2611
export LEIN_JVM_OPTS="-XX:TieredStopAtLevel=1"

export RIPGREP_CONFIG_PATH="$DOTFILES/config/ripgrep/ripgreprc"
