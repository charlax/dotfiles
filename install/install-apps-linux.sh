#!/bin/env bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

set -e
unset -v

log_info "Installing apt packages"

set -v  # display commands before executing

sudo apt update

packages=(autojump  # cd command that leanrs
    dsniff          # includes arpspoof
    fzf             # fuzzy finder
    gdb             # GNU debugger
    gobuster        # busting tool
    hexyl           # A command-line hex viewer
    htop            # process managemenent
    httpie          # http client
    jq              # json query
    python3-venv
    ripgrep         # recursively searches dir for a regex pattern
    shellcheck      # static analysis for shell scripts
    ssh
    strace
    tldr            # quick summary of CLI commands
    tree            # ls in a tree
    xclip           # Linux command line clipboard grabber
    zsh
)

sudo apt install -y "${packages[@]}"

unset -v

#
# SHOULD BE LAST, requires user action
#

printf "\nChanging default shell"
chsh --shell /usr/bin/zsh

printf "\nDefault shell changed, please log out and log back again"
