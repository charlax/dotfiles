# GO
export GOPATH=$HOME/go-space

# Core paths

export PATH="/usr/local/bin:/usr/local/sbin:$ZSH/bin:$PATH:$HOME/bin:$GOPATH/bin"
export MANPATH="/usr/local/man:/usr/local/git/man:$MANPATH"
export DOTFILES="$HOME/.dotfiles/"

[[ -e /usr/texbin ]] && export PATH="/usr/texbin:$PATH"
[[ -e /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh
[[ -s `brew --prefix 2> /dev/null`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

dropbox_config=$HOME/.dropbox/info.json
[[ -e $dropbox_config ]] && export DROPBOX_FOLDER=`cat $dropbox_config | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["personal"]["path"]'`

export CODE_PATH="$HOME/Documents/Dev"
# Override if Dropbox is there
[[ -n ${DROPBOX_FOLDER+x} ]] && export CODE_PATH="$DROPBOX_FOLDER/Code"

# virtualenvwrapper
export PROJECT_HOME="$CODE_PATH"
export WORKON_HOME="$HOME/.virtualenvs"
