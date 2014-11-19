#!/bin/bash

DIFF_AGAINST='master'

git diff --name-only $DIFF_AGAINST | rsync --files-from=- -avz -e ssh . $@
