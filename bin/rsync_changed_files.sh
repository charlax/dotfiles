#!/bin/bash

DIFF_AGAINST='master'

function usage {
    echo "Usage: $0 rsync_args"
    exit 0
}

function check_args {
    if [[ $# -eq 0 ]]; then
        usage
    fi
}

check_args "$@"
echo "git adding"
git add .

echo ""
echo "Pushing all files"
git diff --name-only --diff-filter=ACMRTUXB "$DIFF_AGAINST" | rsync --files-from=- -avz -e ssh . "$@"

# echo ""
# echo "Removing deleted files"
# git diff --name-only --diff-filter=D $DIFF_AGAINST | ssh $@ rm
