#!/usr/bin/env bash


echo ""
echo "Installing Apps"
echo ""
echo "Spectacle: window manager"
echo ""

set -v

brew cask install \
    adobe-acrobat-reader \
    adoptopenjdk8 \
    calibre \
    cyberduck \
    docker \
    firefox \
    homebrew/cask-versions/google-chrome-canary \
    libreoffice \
    postman \
    sequel-pro \
    spectacle \
    transmission \
    typora \
    visual-studio-code \
    vlc \
    whatsapp
