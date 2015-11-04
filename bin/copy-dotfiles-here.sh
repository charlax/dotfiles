mkdir -p .dotfiles
cd .dotfiles
git archive --format=tar --remote=~/.dotfiles/ HEAD | tar xf -
cd ..
python ~/.dotfiles/install.py --symlink-base .

# Some computer have old git version
sed -i '' -e 's/default = simple/default = current/' .dotfiles/git/gitconfig
