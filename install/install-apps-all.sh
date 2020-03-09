#!/usr/bin/env bash

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

log_info "Installing common brew packages"

packages=(broot      # better tree
    cw           # aws cloudwatch logs
    )

brew tap lucagrulla/tap
brew update
brew install "${packages[@]}"

log_info "Installing vim"
"$current_dir/install-vim.sh"

log_info "Installing Python software with pipx"

pipx install glances || true     # an htop alternative
pipx install yq || true          # jq for yaml
pipx install awsebcli || true
pipx install vim-vint            # vimscript linter

echo ""
echo "Running update script to install the rest"
update-everything
