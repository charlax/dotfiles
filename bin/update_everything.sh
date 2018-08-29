#!/usr/bin/env zsh

set -x
set -e

ssh-add -A
brew update

# NOTE: when using pinned packages, brew upgrade fails
brew upgrade  || true
brew prune
brew cleanup
brew cask upgrade
brew doctor || true
brew cask doctor || true

echo "Done."

echo "Installing/updating pip"
pip3 install --user --upgrade pip

echo "Installing/updating pipenv"
pip3 install --user --upgrade pipenv

echo "Installing/updating black (Python code formatter)"
pip3 install --user black

echo "Installing/updating awscli"
pip3 install --user --upgrade awscli

echo "Installing/updating ipython"
pip3 install --user --upgrade ipython

echo "Updating Vim dotfiles"
$VIM_DOTFILES/update-plugins.sh

echo "Updating npm"
npm install npm@latest -g

# Rebuild completions
rm -f ~/.zcompdump; compinit
