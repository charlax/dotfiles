#!/usr/bin/env bash

# shellcheck source=./helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

set -e
unset -v

brew update > /dev/null

log_info "Installing brew packages"

packages=(arp-scan   # ARP scanner
    autojump
    automake
    bat        # A cat(1) clone with wings.
    cheat      # cheatsheets for commands
    coreutils
    ctags
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
    gnupg
    hashcat            # advanced pasword recovery
    hexyl     # A command-line hex viewer
    highlight
    htop       # process management
    httpie     # CLI http client
    hub
    jq         # json formatting
    john-jumbo  # john the ripper
    macvim
    miller     # like awk, sed, cut, join, and sort for CSV, TSV, and tabular JSON
    mysql
    ncdu       # ncurses disk usage
    nmap               # port scanner
    node
    openvpn          # vpn
    pandoc
    pinentry-mac    # Use Keychain for GPG (Mac-only)
    pipx            # Install and Run Python Applications in Environments
    python
    python3
    redis
    rg         # ripgrep, fast file searching
    rmtrash
    shellcheck   # static analysis for shell scripts
    shfmt        # A shell parser, formatter, and interpreter
    telnet
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

brew update
brew install "${packages[@]}"


printf "\nInstalling fzf shell bindings"
/usr/local/opt/fzf/install
