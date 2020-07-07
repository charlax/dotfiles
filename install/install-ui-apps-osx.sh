#!/usr/bin/env bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

log_info "Installing UI Apps"

set -v

apps=(1password
    adobe-acrobat-reader
    # adoptopenjdk8  unavailable??
    alfred
    calibre
    cyberduck
    discord
    docker
    google-chrome
    firefox
    homebrew/cask-versions/google-chrome-canary
    iterm2
    libreoffice
    mactex
    openvpn-connect
    postman
    sequel-pro
    slack
    spectacle
    spotify
    transmission
    typora
    visual-studio-code
    vlc
    whatsapp
    wireshark
    zettlr              # Zettlekasten method
    )

brew cask install "${apps[@]}"

# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$DOTFILES/iterm"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
