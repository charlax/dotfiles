mkdir -p .dotfiles
cd .dotfiles
git archive --format=tar --remote=~/.dotfiles/ HEAD | tar xf -
cd ..
python ~/.dotfiles/install.py --symlink-base .
