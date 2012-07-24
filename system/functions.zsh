function git-clean-orig {
    git status -su | grep -e"\.orig$" | cut -f2 -d" " | xargs rm
}
function git-show-orig {
    git status -su | grep -e"\.orig$" | cut -f2 -d" "
}
function remove-pyc-files {
    find . -name "*.pyc" -exec rm -rf {} \;
}
