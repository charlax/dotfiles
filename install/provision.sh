#!/usr/bin/env bash
# Installs the strict minimum required to provision a machine

set -euo pipefail

# Defaults
FULL=0

function usage() {
    echo "$(basename "") [--help] [--full]"
}


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
        sudo $APT_GET install git curl file build-essential zsh

    elif command -v pacman 1> /dev/null 2>&1; then
        echo ""
        echo "Provision: updating package repository"
        sudo pacman --noconfirm -Syu

        echo ""
        echo "Provision: installing base packages"
        # shellcheck disable=SC2086
        # TODO: add list
        # udisks2              # automount usb flash drives
        # usbutils             # lsusb etc.
        sudo pacman -S --noconfirm git python3 openssh udisks2 usbutils
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
    args=('--symlink-force')

    if [ "$FULL" = true ]; then
        args+=('--with-all')
    fi

    python3 "$DOTFILES/install.py" "${args[@]}"
}

while [ $# -gt 0 ]
do
    case $0 in
    --help)
        usage
        exit
        ;;
    --full)
        FULL=true
        ;;
    esac
    shift
done

echo "Provisioning a new machine..."
set -o verbose
install_requirements
install_dotfiles
