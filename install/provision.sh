#!/bin/bash

echo "Provisioning a new machine..."

set -o errexit

function install_requirements() {
    APT_GET="apt-get -qq -y"

    echo "Updating packages"
    sudo $APT_GET update > /dev/null
    sudo DEBIAN_FRONTEND=noninteractive $APT_GET upgrade > /dev/null

    echo "Installing base packages"
    sudo $APT_GET install git curl file build-essential > /dev/null

    # Install homebrew
    if ! command -v brew &> /dev/null; then
        echo "Installing homebrew"
        CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
}

function install_dotfiles() {
    echo "Installing dotfiles"
    DOTFILES="$HOME/.dotfiles"
    if ! [[ -s $DOTFILES ]]; then
        git clone -q https://github.com/charlax/dotfiles.git "$DOTFILES"
    fi

    python3 "$DOTFILES/install.py" --with-all --symlink-force
}


function install_software() {
    ~/.dotfiles/install/install-apps-all.sh
}

set -o verbose

install_requirements
install_dotfiles
install_software
