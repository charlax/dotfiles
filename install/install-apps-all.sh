#!/bin/bash

set -e
unset -v

current_dir=$(dirname "$0")

case "$OSTYPE" in
    "linux-gnu")
        $current_dir/install-apps-linux.sh
        ;;

    "darwin19")
        $current_dir/install-apps-osx.sh
        $current_dir/install-ui-apps-osx.sh
        ;;

esac

