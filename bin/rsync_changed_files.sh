#!/bin/bash

DIFF_AGAINST='master'

function usage {
    echo "Usage: $0 rsync_args"
    exit 0
}

function check_args {
    if [[ "$@" = "" ]]; then
        usage
    fi
}

check_args "$@"
git diff --name-only --diff-filter=ACMRTUXB $DIFF_AGAINST | rsync --files-from=- -avz -e ssh . $@
