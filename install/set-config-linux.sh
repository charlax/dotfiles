#!/usr/bin/env bash

set -e
set -v

# to find gnome settings, run:
# $ dconf watch /
# then make the change

# NOTE: settings in xfce: 430, 41
gsettings set org.gnome.desktop.peripherals.keyboard delay 200
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
