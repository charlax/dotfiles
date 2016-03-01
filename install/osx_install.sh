set -x
set -e

brew update
brew install -U ack zsh git coreutils zsh-completions rmtrash automake wget mercurial git-flow python python3 autojump hub unrar highlight miller autoenv fzf

# Install fzf shell bindings
/usr/local/opt/fzf/install
