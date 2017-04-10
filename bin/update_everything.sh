set -x
set -e

ssh-add -A
brew update
brew upgrade
brew prune
brew doctor
brew cask doctor

# Rebuild completions
rm -f ~/.zcompdump; compinit
