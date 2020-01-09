#!/bin/env bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

set -e

log_info "Installing apt packages"

set -o verbose

sudo apt update

packages=(autojump  # cd command that leanrs
    dsniff          # includes arpspoof
    exhuberant-ctags
    fzf             # fuzzy finder
    gdb             # GNU debugger
    gobuster        # busting tool
    golang          # the Go programming language
    hexyl           # A command-line hex viewer
    htop            # process managemenent
    httpie          # http client
    jq              # json query
    pandoc
    pipx            # Install and Run Python Applications in Environments
    python3-pip
    python3-venv
    ripgrep         # recursively searches dir for a regex pattern
    shellcheck      # static analysis for shell scripts
    ssh
    strace
    tldr            # quick summary of CLI commands
    tree            # ls in a tree
    vim-nox         # Vim with scripting support
    xclip           # Linux command line clipboard grabber
    zsh
)

sudo apt install -y "${packages[@]}"

set +o verbose

#
# SHOULD BE LAST, requires user action
#

CURRENT_SHELL=$(perl -e '@x=getpwuid($<); print $x[8]')

if [[ ! "$CURRENT_SHELL" =~ "zsh" ]]; then
    log_info "Changing default shell"
    chsh --shell /usr/bin/zsh

    log_info "Default shell changed, please log out and log back again"
fi
