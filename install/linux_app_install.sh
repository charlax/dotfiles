set -x
set -e

echo "Installing xclip: Linux command line clipboard grabber"
apt-get install -y xclip

echo "Installing zsh"
apt-get install -y zsh

echo "Changing default shell"
chsh --shell /usr/bin/zsh

echo "Default shell changed, please log out and log back again"
