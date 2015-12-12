# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -hF --color"
  alias l="gls -lAh --color"
  alias ll="gls -lh --color"
  alias la='gls -A --color'
fi

alias v="vim"
alias p="ipython"

alias tf='tail -f'

alias ka9='killall -9'
alias k9='kill -9'

# Python virtualenv
alias aa='source env/bin/activate'
alias aactivate='source env/bin/activate'

alias grep='grep --color=auto'

# Git
alias g='git'
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gcma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gr='git commit --amend' # git recommit
alias gra='git add . && git commit --amend'
alias grm='git rebase master'
alias gpu='git pull'
alias gcl='git clone'
alias grepush='git recommit && git push -f'
alias gsp='git stash && git pull && git stash pop'

# setup.py
alias pypi_submit="python setup.py register sdist bdist upload"

# Python
alias venv='python -m venv'
alias serve='python3 -m http.server'
alias pydoc='python -m pydoc'
alias pdb='python -m ipdb'
alias pytime='python -m timeit'
alias pyprof='python -m profile'
alias jcat='python -m json.tool'
alias cal='python -m calendar'

# ctags
alias ctg='ack -f --type=python . | ctags -L - -f tags'
alias ctag='ctg'

# tmux
alias tma="if tmux has; then tmux attach; else tmux new; fi"

# Cheatsheet
alias cheatsheet="vim ~/.dotfiles/cheatsheet.txt"

# Vagrant
va () {
    boxer v $VAGRANTNAME $@
}
alias vassh='va -c ssh'

# Mac Os X
alias chrome='open -a "Google Chrome"'
alias iawriter='open -a "IA Writer"'
