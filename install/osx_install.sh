set -x
set -e

brew update
brew install -U zsh git coreutils zsh-completions rmtrash automake wget mercurial git-flow python python3 autojump hub unrar highlight miller autoenv fzf dos2unix the_silver_searcher

# Install fzf shell bindings
/usr/local/opt/fzf/install
