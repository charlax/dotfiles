#!/bin/bash
# Provision a new machine

set -o errexit

sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo apt-get install -y git curl file build-essential

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

DOTFILES="$HOME/.dotfiles"
git clone https://github.com/charlax/dotfiles.git $DOTFILES

python3 $DOTFILES/install.py --with-all

~/.dotfiles/install/install-apps-all.sh
