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

packages=(awscli  # AWS command line
    binwalk       # inspect files
    broot         # better tree
    csvq          # query csv from command line
    cw            # aws cloudwatch logs
    github/gh/gh  # Github cli
    renameutils   # imv (faster rename) etc.
    terraform     # infrastructure management
    sqlmap        # sql injection tool
    )

brew tap lucagrulla/tap
brew update
brew install "${packages[@]}"

log_info "Installing vim"
"$current_dir/install-vim.sh"

log_info "Installing Python software with pipx"

pipx install awsebcli || true
pipx install glances || true     # an htop alternative
pipx install ipython || true     # better python console
pipx install poetry || true      # package management
pipx install pre-commit || true  # pre-commit hooks
pipx install vim-vint            # vimscript linter
pipx install wfuzz || true       # the web fuzzer
pipx install yq || true          # jq for yaml

log_info "Installing pipenv"
pip install --user pipenv

# npm install -g prettier

echo ""
echo "Running update script to install the rest"
update-everything
