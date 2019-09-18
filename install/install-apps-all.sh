#!/bin/bash

set -x
set -e

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    $DOTFILES/install/install-apps-linux.sh
fi

# TODO: handle Mac Os X
