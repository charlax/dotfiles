#!/bin/bash
mkdir -p .dotfiles
cd .dotfiles || exit
git archive --format=tar --remote=~/.dotfiles/ HEAD | tar xf -
cd .. || exit
python ~/.dotfiles/install.py --symlink-base .

# Some computer have old git version
sed -i '' -e 's/default = simple/default = current/' .dotfiles/git/gitconfig
