export EDITOR="vim"
export EDITOR_GUI="mvim"
export SHELL=$(which zsh)

# Unlimited psql history
# http://craigkerstiens.com/2013/02/13/How-I-Work-With-Postgres/
export HISTFILESIZE=
export HISTSIZE=

[[ -e /usr/local/opt/autoenv/activate.sh ]] && source /usr/local/opt/autoenv/activate.sh

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
