#!/usr/bin/env bash

# grc overides for ls
if command -v "eza" > /dev/null 2>&1; then
    alias ls='eza'
    alias l='eza -l'
    alias ll='eza -lh'
    alias la='eza -a'
elif command -v "gls" > /dev/null 2>&1; then
    alias ls='gls -hF --color'
    alias l='gls -lAh --color'
    alias ll='gls -lh --color'
    alias la='gls -A --color'
else
    alias ls='ls --color=auto -hF'
    alias l='ls -lAh --color'
    alias ll='ls -lh --color'
    alias la='ls -A --color'
fi

# Create directory and move to it
mkcd () {
    mkdir -p "$1" && cd "$1" || return
}

c () {
    cd "$CODE_PATH/$1" || return
}

if command -v kubectl > /dev/null 2>&1; then
    alias k="kubectl"
fi

if command -v "gcp" > /dev/null 2>&1; then
    alias cp="gcp"
fi

if command -v "gmake" > /dev/null 2>&1; then
    alias make="gmake"
fi

# Find file (defined in functions)
alias f="findfile"

# Text editors
alias m="edit"
alias e="edit"
alias v="vim"
alias vr="mvim"
alias nv="nvim"
alias mr="mvim"
alias vscode="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

# single quotes used here to prevent variable expansion at definition time
alias edit-dotfiles='$EDITOR $DOTFILES'

alias tf='tail -f'

alias ka9='killall -9'
alias k9='kill -9'

alias grep='grep --color=auto'

# Git
alias ga='git add'
alias gp='git push'
# git l is defined in git/gitconfig
alias gl='git l'
alias gs='git status'
alias gd='git diff'
alias gdca='git diff --cached'
alias gds='git diff --staged'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gcma='git commit -am'
alias gcam='git commit -am'
alias gc='git checkout'
alias gr='git commit --amend' # git recommit
alias gra='git add . && git commit --amend'
alias grm='git rebase master'
alias gpu='git pull'
alias gcl='git clone'
alias grepush='git recommit && git push -f'
alias gsp='git stash && git pull && git stash pop'
alias gpgp='git pull && git push'
alias gpushcurrent='git push -u origin HEAD'
# git-done is a script defined in bin/
alias gogo='git-done'
alias gg='git-done'

gb () {
    # shellcheck disable=SC2063 # it's not a regex
    git checkout "$(git branch -v --sort=-committerdate | grep -v '* .*' | fzf | tr -s ' ' | cut -d ' ' -f 2)"
}

# Python
alias p="ipython"
alias p3="python3"
alias python="python3"
alias pypi_submit="python setup.py register sdist bdist upload"
alias venv='python -m venv'
alias serve='python3 -m http.server'
alias pydoc='python -m pydoc'
alias pdb='python -m ipdb'
alias pytime='python -m timeit'
alias pyprof='python -m profile'
alias jcat='python -m json.tool'
alias cal='python -m calendar'
# pretty print standard input
alias pprint='python -c "import pprint, sys, ast; pprint.pprint(ast.literal_eval(sys.stdin.read()))"'

aactivate() {
    if [ -f .env/bin/activate ]; then
        source .env/bin/activate
    elif [ -f .venv/bin/activate ]; then
        source .venv/bin/activate
    elif [ -f env/bin/activate ]; then
        source env/bin/activate
    else
        echo "No virtual environment found."
    fi
}

rgpython () {
    # Search for a string in Python source
    rg "$1" "$(python -c 'import sys; print(sys.base_prefix)')"
}

# ctags
alias ctg='g -l --python . | ctags -L - -f tags'
alias ctag='ctg'

# tmux
alias tma="if tmux has; then tmux attach; else tmux new; fi"

alias ack="ag"

alias timestamp="date +'%s'"
alias timestamp_ms="python -c 'import time; print(int(time.time() * 1000))'"

# Mac Os X
if [[ "$OSTYPE" =~ ^darwin ]]; then
    alias chrome='open -a "Google Chrome"'
    alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"

    alias firefox='open -a "Firefox"'
    alias ff='firefox'

    ia () {
        touch "$1" && open -a "IA Writer" "$1"
    }

    alias iawriter='open -a "IA Writer"'
    alias iar="iawriter README*"
fi

alias generate_secret="openssl rand -base64 32"

function generate_uuid () {
    python3 -c "import uuid; print(str(uuid.uuid4()).lower())"
}

alias d='cd ~/Downloads'
alias checkout='cd ~/Downloads && m '
alias br='broot'

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    function pbcopy() {
        xclip -selection clipboard
    }

    function pbpaste() {
        xclip -selection clipboard -o
    }
fi
