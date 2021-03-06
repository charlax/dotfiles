#!/bin/bash

echo "Provisioning a new machine..."

set -o errexit

function install_requirements() {
    APT_GET="apt-get -qq -y"

    echo "Updating package repository"
    # shellcheck disable=SC2086
    sudo $APT_GET update

    echo "Installing base packages"
    # shellcheck disable=SC2086
    sudo $APT_GET install git curl file build-essential
}

function install_dotfiles() {
    echo "Installing dotfiles"
    DOTFILES="$HOME/.dotfiles"
    if ! [[ -d $DOTFILES ]]; then
        git clone -q https://github.com/charlax/dotfiles.git "$DOTFILES"
    fi

    python3 "$DOTFILES/install.py" --with-all --symlink-force
}

set -o verbose

install_requirements
install_dotfiles
