set -e
unset -v

echo ""
echo "Installing packages"
echo ""
echo "dsniff: includes arpspoof"
echo "gdb: GNU debugger"
echo "gobuster: busting tool"
echo "httpie: http client"
echo "jq: json query"
echo "ripgrep: recursively searches directories for a regex pattern"
echo "tldr: quick summary of CLI commands"
echo "tree: ls in a tree"
echo "xclip: Linux command line clipboard grabber"
echo ""

apt-get install -y \
    dsniff \
    gdb \
    gobuster \
    httpie \
    jq \
    python3-venv \
    ripgrep \
    ssh \
    strace \
    tldr \
    tree \
    xclip \
    zsh

#
# SHOULD BE LAST, requires user action
#

echo "\n"
echo "Changing default shell"
chsh --shell /usr/bin/zsh

echo "Default shell changed, please log out and log back again"
