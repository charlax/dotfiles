#!/usr/bin/env bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)

packages=(libreoffice
    slack-desktop
    vim-gtk3
    wireshark
)


sudo apt install -y "${packages[@]}"

IS_CHROME_INSTALLED=$(dpkg-query -W --showformat='${Status}\n' google-chrome-stable|grep "install ok installed")

if [[ "$IS_CHROME_INSTALLED" == "" ]]; then
    log_info "Installing Google Chrome"
    chrome_file="$tmp_dir/google-chrome.deb"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O "$chrome_file"
    sudo dpkg -i "$chrome_file"
fi
