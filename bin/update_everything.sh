#!/usr/bin/env zsh

set -x
set -e

ssh-add -A
brew update
brew upgrade
brew prune
brew doctor
brew cask doctor

echo "Done. Feel free to run brew cleanup from time to time"

echo "Updating pipenv"
pip3 install --user --upgrade pipenv

echo "Updating Vim dotfiles"
$VIM_DOTFILES/update-plugions.sh

# Rebuild completions
rm -f ~/.zcompdump; compinit
