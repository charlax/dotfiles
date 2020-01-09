#!/bin/env bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

set -e
unset -v

brew update > /dev/null

log_info "Installing brew packages"

packages=(arp-scan   # ARP scanner
    autojump
    automake
    awsebcli   # utils for AWS
    bat        # A cat(1) clone with wings.
    cheat      # cheatsheets for commands
    coreutils
    docker-completion
    docker-compose-completion
    docker-machine-completion
    dos2unix
    editorconfig
    exa       # A modern replacement for ls.
    fd        # A simple, fast and user-friendly alternative to 'find'
    findutils
    fswatch   # watch for file changes
    fzf
    git
    go
    hashcat            # advanced pasword recovery
    hexyl     # A command-line hex viewer
    highlight
    httpie     # CLI http client
    hub
    jq         # json formatting
    john-jumbo  # john the ripper
    miller
    mysql
    ncdu       # ncurses disk usage
    nmap               # port scanner
    node
    pre-commit
    python
    python3
    redis
    rg         # file searching
    rmtrash
    shellcheck   # static analysis for shell scripts
    telnet
    the_silver_searcher  # file searching ag command
    tldr       # simplified and community-driven man pages
    tmux
    tree      # display file list in tree
    unrar
    watchexec   # Executes commands in response to file modifications
    wget
    yarn
    zsh
    zsh-completions
)

brew install
brew install "${packages[@]}"


printf "\nInstalling fzf shell bindings"
/usr/local/opt/fzf/install
