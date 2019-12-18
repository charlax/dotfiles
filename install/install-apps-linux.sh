set -e
unset -v

echo ""
echo "Installing packages"
echo ""

apt-get install -y \
    autojump       \ # cd command that learns
    dsniff         \ # includes arpspoof
    fzf            \ # fuzzy finder
    gdb            \ # GNU debugger
    gobuster       \ # busting tool
    htop           \ # process managemenent
    httpie         \ # http client
    jq             \ # json query
    python3-venv   \
    ripgrep        \ # recursively searches dir for a regex pattern
    ssh            \
    strace         \
    tldr           \ # quick summary of CLI commands
    tree           \ # ls in a tree
    xclip          \ # Linux command line clipboard grabber
    zsh

#
# SHOULD BE LAST, requires user action
#

echo "\n"
echo "Changing default shell"
chsh --shell /usr/bin/zsh

echo "Default shell changed, please log out and log back again"
