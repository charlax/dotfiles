#!/usr/bin/env bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)

sudo apt install slack-desktop vim-gtk3


log_info "Installing Google Chrome"

chrome_file="$tmp_dir/google-chrome.deb"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O "$chrome_file"
sudo dpkg -i "$chrome_file"
