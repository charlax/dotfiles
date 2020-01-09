#!/usr/bin/env bash

current_dir=$(dirname "$0")

echo "Create $HOME/Code"
mkdir -p "$HOME/Code"

case "$OSTYPE" in
    "darwin19")
        "$current_dir/set-config-osx.sh"
        ;;
esac
