set -x
set -e

brew update
brew upgrade
brew prune
brew doctor
brew cask doctor

# Rebuild completions
rm -f ~/.zcompdump; compinit
