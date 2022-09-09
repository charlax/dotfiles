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

function create-note {
    ts=$(date +"%Y-%m-%d")
    date_value=$(gdate --iso-8601=seconds)
    echo "Filename? (without .md)"
    read title
    filename="$title $ts.md"

    [[ -s $filename ]] && echo -e "Error: file already exists" && return -1

    echo "---" > $filename
    echo "title: $title" >> $filename
    echo "date: $date_value" >> $filename
    echo "---" >> $filename
    echo "" >> "$filename"
    echo "# $title" >> "$filename"
    echo "" >> "$filename"
    echo "" >> "$filename"

    echo "$filename"
    vim "+normal G$" +startinsert "$filename"
}
alias n=create-note

# cd into whatever is the forefront Finder window.
function cdf {  # short for cdfinder
    thepath=$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
    cd "$thepath" || exit
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

function git-start-branch-from-issue {
    issue=$(gh issue view "$1" --json title,number -t "{{.number}}--{{.title}}" | tr -cs "[:alnum:]" "_")
    git switch -c "ca/$issue"
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

# Simple calculator
function calc() {
        local result=""
        result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
        #                       └─ default (when `--mathlib` is used) is 20
        #
        if [[ "$result" == *.* ]]; then
                # improve the output for decimal numbers
                printf "$result" |
                sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
                    -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
                    -e 's/0*$//;s/\.$//'   # remove trailing zeros
        else
                printf "$result"
        fi
        printf "\n"
}

# Create a new directory and enter it
function md() {
	mkdir -p "$@" && cd "$@"
}

# All the dig info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
	echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
	echo # newline
}
