set -x
set -e

brew update
brew install macvim --override-system-vim
brew install -U zsh git coreutils zsh-completions rmtrash automake wget mercurial python python3 autojump hub unrar highlight miller fzf dos2unix the_silver_searcher findutils tldr go

# Install fzf shell bindings
/usr/local/opt/fzf/install
