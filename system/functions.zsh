#!/usr/bin/env bash

# Go to folder
function code  {
    cd "$CODE_PATH" || exit
}
function forks {
    cd "$FORK_PATH" || exit
}
function dotfiles {
    cd "$DOTFILES" || exit
}

# cd into whatever is the forefront Finder window.
cdf() {  # short for cdfinder
    path=$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
    cd "$path" || exit
}

function remove-orig-files {
    git status -su | grep -e"\.orig$" | cut -f2 -d" " | xargs rm -i
}

function remove-pyc-files {
    find . -name "*.pyc" -exec rm -rf {} \;
}

function remove-trailing-spaces-in-py-files {
    # Trim trailing spaces at end of line
    perl -pi -e "s/ +$//" ./**/*.py
    # Delete empty lines at end of file
    # perl -i -pe "chomp if eof" **/*.py
}

function git-amend-last-commit-set-date-to-now {
    GIT_COMMITTER_DATE="$(date)" git commit --amend --date "$(date)"
}

# Gather data from the output, but starting with a particular line, and ending
# with another.
# http://howardabrams.com/projects/dot-files/sh-functions.html
function clip {
    FIRST=$1
    ENDING=$2
    PADDING=${3:-""}

    perl -ne "\$s=1 if (/$FIRST/); \$s=0 if (/$ENDING/); print \"$PADDING\$_\" if (\$s==1);"
}

# http://tychoish.com/posts/9-awesome-ssh-tricks/#ssh-reagent
ssh-reagent () {
    for agent in $SSH_AUTH_SOCK $STATIC_SSH_AUTH_SOCK /tmp/ssh-*/agent.*; do
        export SSH_AUTH_SOCK=$agent
        if ssh-add -l > /dev/null 2>&1; then
            echo "Found working SSH Agent: ${SSH_AUTH_SOCK}"
            ssh-add -L
            return
        fi
    done
    echo "Cannot find ssh agent - maybe you should reconnect and forward it?"
}

function findfile {
    fd --type f "$@"
    # grep is for coloring in the output
    # find . -path ./node_modules -prune -o -iname "*$1*" -print | grep "$1"
}

psg ()
{
    pgrep "$1"
}

# Make it easier to search ZSH documentation
zman() {
    PAGER="less -g -s '+/^       \"$1\"'" man zshall
}

function whattoalias() {
  history|awk '{print $2}'|awk 'BEGIN {FS="|"} {print $1}'|sort|uniq -c|sort -n|tail -n10
}

# Timestamp to date
function ts {
    date -r "$1"
}

# Display in a tree, ignoring gitignore files
function gtree {
    git_ignore_files=("$(git config --get core.excludesfile)" .gitignore ~/.gitignore)
    ignore_pattern="$(grep -hvE '^$|^#' "${git_ignore_files[@]}" 2>/dev/null|sed 's:/$::'|tr '\n' '\|')"
    if git status &> /dev/null && [[ -n "${ignore_pattern}" ]]; then
      tree -I "${ignore_pattern}" "${@}"
    else
      tree "${@}"
    fi
}
