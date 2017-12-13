[[ -s `brew --prefix 2> /dev/null`/etc/autojump.sh ]] && . $(brew --prefix)/etc/autojump.sh

dropbox_config=$HOME/.dropbox/info.json
[[ -e $dropbox_config ]] && export DROPBOX_FOLDER=$(cat $dropbox_config | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["personal"]["path"]')

export CODE_PATH="$HOME/Documents/Dev"
# Override if Dropbox is there
[[ -n ${DROPBOX_FOLDER+x} ]] && export CODE_PATH="$DROPBOX_FOLDER/Code"

# Go
export GOPATH=$CODE_PATH/golang

# Java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8) >/dev/null 2>&1

# Python
PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"

# Latex
[[ -e /usr/texbin ]] && export PATH="/usr/texbin:$PATH"

# Vim dotfiles
export VIM_DOTFILES="$HOME/.vim"

# Core paths
export PATH="/usr/local/opt/gettext/bin:/usr/local/bin:/usr/local/sbin:$ZSH/bin:$PATH:$HOME/bin:$GOPATH/bin:$PYTHON_BIN_PATH"
export MANPATH="/usr/local/man:/usr/local/git/man:$MANPATH"
export DOTFILES="$HOME/.dotfiles/"
