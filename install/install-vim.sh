#!/usr/bin/env bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

set -e
unset -v

mkdir -p ~/.vim/temp/temp
mkdir -p ~/.vim/temp/backup
mkdir -p ~/.config/nvim

go get -u github.com/nsf/gocode

log_info "Installing all vim plugins"
vim +PlugInstall +qall
