export PATH="/usr/local/bin:/usr/local/sbin:$ZSH/bin:$PATH"
export MANPATH="/usr/local/man:/usr/local/git/man:$MANPATH"
export DOTFILES="$HOME/.dotfiles/"

# virtualenvwrapper
export PROJECT_HOME="$HOME/Documents/Dev"
export WORKON_HOME="~/.virtualenvs"

[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc
[[ -e /usr/local/share/npm/bin ]] && export PATH="/usr/local/share/npm/bin:$PATH"
[[ -e /usr/texbin ]] && export PATH="/usr/texbin:$PATH"
[[ -e /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh


dropbox_config=$HOME/.dropbox/info.json
[[ -e $dropbox_config ]] && export DROPBOX_FOLDER=`cat $dropbox_config | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["personal"]["path"]'`

[[ -n ${DROPBOX_FOLDER+x} ]] && export CODE_PATH="$DROPBOX_FOLDER/Code"
