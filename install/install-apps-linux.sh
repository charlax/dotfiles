set -x
set -e

echo "Installing xclip: Linux command line clipboard grabber"
apt-get install -y xclip

echo "Installing packages"
echo "tldr: quick summary of CLI commands"
echo "dsniff: includes arpspoof"
apt-get install -y zsh tldr dsniff

echo "Changing default shell"
chsh --shell /usr/bin/zsh

echo "Default shell changed, please log out and log back again"