set -x
set -e

echo "Installing xclip: Linux command line clipboard grabber"
apt-get install -y xclip

# tldr: quick docs about cli
apt-get install -y zsh tldr

echo "Changing default shell"
chsh --shell /usr/bin/zsh

echo "Default shell changed, please log out and log back again"
