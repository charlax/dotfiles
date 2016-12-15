set -x
set -e

echo "If you get publickey errors, run ssh-add -A"
brew update
brew upgrade
brew prune
brew doctor
brew cask doctor

# Rebuild completions
rm -f ~/.zcompdump; compinit
