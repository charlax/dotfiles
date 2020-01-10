#!/usr/bin/env bash

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

set -e

log_info "Finishing vim installation"

set -v
go get -u github.com/nsf/gocode
vim +PlugInstall +qall
