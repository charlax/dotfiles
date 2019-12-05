#!/bin/bash

echo "Create $HOME/Code"
mkdir -p $HOME/Code

case "$OSTYPE" in
    "linux-gnu")
        $current_dir/set-config-osx.sh
        ;;
esac
