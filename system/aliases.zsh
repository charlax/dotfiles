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
alias m="mvim"
alias p="ipython"
alias g="git"
alias gs="git status"

alias tf='tail -f'

alias ka9='killall -9'
alias k9='kill -9'

alias grep='grep --color=auto'
