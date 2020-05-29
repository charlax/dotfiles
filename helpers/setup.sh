#!/bin/env bash

# No POSIX way to get dir of sourced script.
[ "$BASH_VERSION" ] && thisDir="$(dirname "${BASH_SOURCE[0]}")"
[ "$ZSH_VERSION" ] && thisDir="$(dirname "$0")"
[ -z "$thisDir" ] && thisDir="./helpers"

# Get colour aliases.
# shellcheck source=./colours.sh
. "$thisDir"/colours.sh

function log_info() {
  printf "\n${GREEN}%s${NC}\n" "$@"
}
