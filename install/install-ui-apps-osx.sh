#!/usr/bin/env bash


echo ""
echo "Installing Apps"
echo ""
echo "Discord: chat"
echo "Spectacle: window manager"
echo ""

set -v

brew cask install \
    adobe-acrobat-reader \
    adoptopenjdk8 \
    calibre \
    cyberduck \
    discord \
    docker \
    firefox \
    homebrew/cask-versions/google-chrome-canary \
    libreoffice \
    postman \
    sequel-pro \
    slack \
    spectacle \
    transmission \
    typora \
    visual-studio-code \
    vlc \
    whatsapp
