#!/usr/bin/env bash

# shellcheck source=./helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

set -e
unset -v

brew update > /dev/null

log_info "Installing brew packages"

# Optional
# john-jumbo       # john the ripper

packages=(arp-scan   # ARP scanner
    automake
    bat              # A cat(1) clone with wings https://github.com/sharkdp/bat
    cheat            # cheatsheets for commands
    coreutils
    ctags
    docker-completion
    docker-compose-completion
    docker-machine-completion
    dos2unix
    editorconfig
    exa              # modern replacement for ls https://the.exa.website/
    fd               # alternative to 'find' https://github.com/sharkdp/fd
    findutils
    fswatch          # watch for file changes
    fzf              # fuzzy finder https://github.com/junegunn/fzf
    git
    go
    gnupg
    hashcat          # advanced pasword recovery
    hexyl            # hex viewer https://github.com/sharkdp/hexyl
    highlight
    htop             # process viewer https://htop.dev/
    httpie           # CLI http client
    jq               # json formatting
    macvim
    miller           # like awk, sed, cut, join, and sort for CSV, TSV, and tabular JSON https://github.com/johnkerl/miller
    mysql
    ncdu             # ncurses disk usage https://dev.yorhel.nl/ncdu
    nmap             # port scanner
    node
    openvpn          # vpn
    pandoc
    pinentry-mac     # Use Keychain for GPG (Mac-only)
    pipx             # Install and Run Python Applications in Environments
    python
    python3
    redis
    rename           # mass rename
    rg               # ripgrep, fast file searching https://github.com/BurntSushi/ripgrep
    rmtrash
    shellcheck       # static analysis for shell scripts
    shfmt            # shell parser, formatter, and interpreter https://github.com/mvdan/sh
    telnet
    tldr             # simplified and community-driven man pages
    tmux
    tree             # display file list in tree
    unrar
    wget
    yarn
    zsh
    zsh-completions
)

brew update
brew install "${packages[@]}"


printf "\nInstalling fzf shell bindings"
/usr/local/opt/fzf/install
