#!/usr/bin/env bash

# shellcheck source=./helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

APT_GET="apt-get -qq -y"

function set_default_shell() {
    local default_shell
    default_shell=$(grep "^$(id -un):" /etc/passwd | cut -d : -f 7-)
    if ! [[ "$default_shell" =~ "zsh" ]]; then
        log_info "Changing default shell"
        # Works on AWS Ubuntu
        sudo chsh -s "$(which zsh)" "$(whoami)"
        # chsh --shell /usr/bin/zsh

        log_info "Default shell changed, this will take effect only after login/logout"
    fi
}

function install_ui {
    local tmp_dir
    local packages

    tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
    packages=(libreoffice
        slack-desktop
        vagrant
        vim-gtk3
        wireshark
    )

    # shellcheck disable=SC2086
    sudo $APT_GET install "${packages[@]}" > /dev/null

    IS_CHROME_INSTALLED=$(dpkg-query -W --showformat='${Status}\n' google-chrome-stable|grep "install ok installed")

    if [[ "$IS_CHROME_INSTALLED" == "" ]]; then
        log_info "Installing Google Chrome"
        chrome_file="$tmp_dir/google-chrome.deb"
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O "$chrome_file"
        sudo dpkg -i "$chrome_file"
    fi
}

set -e

log_info "Installing apt packages"

set -o verbose

# shellcheck disable=SC2086
sudo DEBIAN_FRONTEND=noninteractive $APT_GET update > /dev/null

# To add:
# vscode
# shutter # screenshot tool
# peek    # screencast tool
# peco    # Simplistic interactive filtering tool

packages=(autojump  # cd command that leanrs
    # docker.io     # broken as of 03/23/2021
    dsniff          # includes arpspoof
    exuberant-ctags
    fzf             # fuzzy finder
    gdb             # GNU debugger
    gobuster        # busting tool
    golang          # the Go programming language
    htop            # process managemenent
    httpie          # http client
    jq              # json query
    neovim          # heavily refactored vim fork
    pandoc
    pipx            # Install and Run Python Applications in Environments
    python3-pip
    python3-venv
    ripgrep         # recursively searches dir for a regex pattern
    shellcheck      # static analysis for shell scripts
    ssh
    strace
    tldr            # quick summary of CLI commands
    tmux            # terminal multiplexer
    tree            # ls in a tree
    vim-nox         # Vim with scripting support
    xclip           # Linux command line clipboard grabber
    zsh
)

# shellcheck disable=SC2086
sudo $APT_GET install "${packages[@]}" > /dev/null


set +o verbose

#
# SHOULD BE LAST, requires user action
#

set_default_shell

exec zsh --login
