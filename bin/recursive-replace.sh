#!/bin/zsh

FIND=ag

# replace="'s/"$1"/"$2"/g'"
# find ./ -name "*.py" -print0 | xargs -0 echo "$1 $2"
# DOES NOT WORK
# find ./ -name "*.py" -print0 | xargs -0 perl -p -i -e $replace
$FIND -l $1 | xargs perl -pi -E 's/'$1'/'$2'/g'
