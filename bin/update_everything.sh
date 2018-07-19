#!/usr/bin/env zsh

set -x
set -e

ssh-add -A
brew update
brew upgrade
brew prune
brew cleanup
brew cask upgrade
brew doctor
brew cask doctor

echo "Done."

echo "Updating pipenv"
pip3 install --user --upgrade pipenv

echo "Updating Vim dotfiles"
$VIM_DOTFILES/update-plugions.sh

echo "Updating npm"
npm install npm@latest -g

# Rebuild completions
rm -f ~/.zcompdump; compinit
