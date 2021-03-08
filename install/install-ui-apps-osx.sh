#!/usr/bin/env bash

# shellcheck source=./helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

log_info "Installing UI Apps"

set -v

brew tap homebrew/cask-fonts


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
    font-roboto-nerd-font
    homebrew/cask-versions/google-chrome-canary
    iterm2
    libreoffice
    mactex
    openvpn-connect
    postman
    rectangle           # window management
    sequel-pro
    spotify
    transmission
    typora
    vagrant             # useful for installing kali
    visual-studio-code
    vlc
    whatsapp
    wireshark
    zettlr              # Zettlekasten method
    )

brew install --cask "${apps[@]}"

# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$DOTFILES/iterm"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# ==============================================================================
# Rectangle
# ==============================================================================

rectangle_config="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"
if [ ! -L "$rectangle_config" ]; then
  log_info "Overwriting Rectangle shortcuts with link to dotfiles ones."
  [ -e "$rectangle_config" ] && mv "$rectangle_config" "$HOME/Downloads/SpectacleShortcuts.bak.json"
  ln -s "$DOTFILES/rectangle/com.knollsoft.Rectangle.plist" "$rectangle_config"
fi
