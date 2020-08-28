#!/bin/bash
# Provision a new machine

APT_GET="apt-get -qq -y"

set -o errexit

sudo $APT_GET update > /dev/null
sudo DEBIAN_FRONTEND=noninteractive $APT_GET upgrade > /dev/null
sudo $APT_GET install git curl file build-essential > /dev/null

# Install homebrew
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

DOTFILES="$HOME/.dotfiles"
git clone -q https://github.com/charlax/dotfiles.git "$DOTFILES"

python3 "$DOTFILES/install.py" --with-all --symlink-force

~/.dotfiles/install/install-apps-all.sh
