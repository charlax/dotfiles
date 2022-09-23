#!/usr/bin/env bash

# shellcheck source=./helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"
current_dir=$(dirname "$0")

set -e

log_info "Finishing vim installation"

set -v
go install github.com/nsf/gocode@latest

"$current_dir/../bin/update-vim-plugins"
