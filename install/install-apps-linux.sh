set -x
set -e

echo "Installing xclip: Linux command line clipboard grabber"
apt-get install -y xclip

echo "Installing packages"
echo "tldr: quick summary of CLI commands"
echo "dsniff: includes arpspoof"
echo "ripgrep: recursively searches directories for a regex pattern"
echo "gdb: GNU debugger"
echo "gobuster: busting tool"
echo "httpie: http client"
echo "jq: json query"
echo "tree: ls in a tree"
apt-get install -y zsh tldr dsniff ripgrep gdb gobuster httpie jq tree

#
# SHOULD BE LAST, requires user action
#

echo "\n"
echo "Changing default shell"
chsh --shell /usr/bin/zsh

echo "Default shell changed, please log out and log back again"
