set -x
set -e

brew update
brew install macvim --override-system-vim

echo "Installing:"
echo "rg: file searching"
echo "the_silver_searcher: file searching (ag command)"

brew install -U zsh git coreutils zsh-completions rmtrash automake wget mercurial python python3 autojump hub unrar highlight miller fzf dos2unix the_silver_searcher findutils goa rg

echo "Installing fswatch: watch for file changes"
brew install fswatch

echo "Installing jq: json formatting"
brew install jq

echo "Installing httpie: CLI http client"
brew install httpie

echo "Installing node.js"
brew install node yarn

echo "Installing tmux"
brew install tmux

echo "Installing mysql"
brew install mysql

echo "Installing telnet"
brew install telnet

echo "Installing docker completion"
brew install docker-completion docker-compose-completion docker-machine-completion

echo "Installing ncdu: ncurses disk usage"
brew install ncdu

echo "Installing tldr: simplified and community-driven man pages"
brew install tldr

echo "Installing editorconfig"
brew install editorconfig

echo "Installing fzf shell bindings"
/usr/local/opt/fzf/install

echo "Run update script to install the rest"
update_everything.sh
