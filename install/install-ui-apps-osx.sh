#!/usr/bin/env bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

log_info "Installing UI Apps"

set -v

apps=(adobe-acrobat-reader
    # adoptopenjdk8  unavailable??
    alfred
    calibre
    cyberduck
    discord
    docker
    firefox
    homebrew/cask-versions/google-chrome-canary
    iterm2
    libreoffice
    mactex
    postman
    sequel-pro
    slack
    spectacle
    transmission
    typora
    visual-studio-code
    vlc
    whatsapp
    wireshark
    )

brew cask install "${apps[@]}"
