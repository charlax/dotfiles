#!/bin/sh
#
# Custom Git merge driver - merges PO files using msgcat(1)
#
# - Install gettext
#
# - Place this script in your PATH
# 
# - Add this to your .git/config :
#
#   [merge "pofile"]
#     name = Gettext merge driver
#     driver = git merge-po %O %A %B
# 
# - Add this to .gitattributes :
# 
#   *.po   merge=pofile
#   *.pot  merge=pofile
#
# - When merging branches, conflicts in PO files will be maked with "#-#-#-#"
# 
O=$1
A=$2
B=$3

# Extract the PO header from the current branch (top of file until first empty line)
header=$(mktemp /tmp/merge-po.XXXX)
sed -e '/^$/q' < $A > $header

# Merge files, then repair header
temp=$(mktemp /tmp/merge-po.XXXX)
msgcat -o $temp $A $B
msgcat --use-first -o $A $header $temp

# Clean up
rm $header $temp

# Check for conflicts
conflicts=$(grep -c "#-#" $A)
test $conflicts -gt 0 && exit 1
exit 0
