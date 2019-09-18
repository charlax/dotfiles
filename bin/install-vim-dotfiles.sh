#!/bin/bash

set -e
set -x

cd ~/Downloads
curl https://raw.githubusercontent.com/charlax/dotvim/master/install.py | python3
