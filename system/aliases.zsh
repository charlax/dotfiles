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

alias grep='grep --color=auto'

# Git
alias g="git"
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gr='git commit --amend' # git recommit
alias gra='git add . && git commit --amend && git push -f'
alias grm='git rebase master'
alias gpu='git pull'
alias gcl='git clone'
alias grepush='git recommit && git push -f'

# setup.py
alias pypi_submit="python setup.py register sdist bdist upload"
