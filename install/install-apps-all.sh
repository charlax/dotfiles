#!/bin/bash

set -x
set -e

current_dir=$(dirname "$0")

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    $current_dir/install-apps-linux.sh
fi

# TODO: handle Mac Os X
