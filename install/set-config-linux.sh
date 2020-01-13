#!/usr/bin/env bash

set -e
set -v

# to find gnome settings, run:
# $ dconf watch /
# then make the change

gsettings set org.gnome.desktop.peripherals.keyboard delay 200
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20

# Natural scrolling
gsettings set org.gnome.desktop.peripherals.touchpad.natural-scroll true
gsettings set org.gnome.desktop.peripherals.mouse.natural-scroll true

gsettings set org.gnome.settings-daemon.plugins.color.night-light-enabled true
gsettings set org.gnome.desktop.interface.gtk-theme 'Pop-dark'
