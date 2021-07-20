#!/bin/bash

echo "Provisioning a new machine..."

set -o errexit

function install_requirements() {
    if command -v apt 1>/dev/null 2>&1; then
        APT_GET="apt-get -qq -y"

        echo ""
        echo "Provision: updating package repository"
        # shellcheck disable=SC2086
        sudo $APT_GET update

        echo ""
        echo "Provision: installing base packages"
        # shellcheck disable=SC2086
        sudo $APT_GET install git curl file build-essential

    elif command -v pacman 1> /dev/null 2>&1; then
        echo ""
        echo "Provision: updating package repository"
        sudo pacman --noconfirm -Syu

        echo ""
        echo "Provision: installing base packages"
        # shellcheck disable=SC2086
        sudo pacman -S --noconfirm git python3

    fi
}

function install_dotfiles() {
    DOTFILES="$HOME/.dotfiles"
    if ! [[ -d $DOTFILES ]]; then
        echo ""
        echo "Provision: cloning dotfiles"
        git clone -q https://github.com/charlax/dotfiles.git "$DOTFILES"
    fi

    echo ""
    echo "Provision: running dotfiles install.py"
    python3 "$DOTFILES/install.py" --with-all --symlink-force
}

set -o verbose

install_requirements
install_dotfiles
