#!/bin/bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

set -e
unset -v

current_dir=$(dirname "$0")

case "$OSTYPE" in
    "linux-gnu")
        "$current_dir"/install-apps-linux.sh
        ;;

    "darwin19")
        "$current_dir"/install-apps-osx.sh
        "$current_dir"/install-ui-apps-osx.sh
        ;;
esac

# Needs to happen after OS-specific install

echo ""
echo "Installing pipx"
python3 -m pip install --user pipx

log_info "Installing Python software with pipx"

pipx install glances  # an htop alternative
pipx install cheat    # cheatsheets

echo ""
echo "Running update script to install the rest"
update-everything
