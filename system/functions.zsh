function remove-orig-files {
    git status -su | grep -e"\.orig$" | cut -f2 -d" " | xargs rm -i
}

function remove-pyc-files {
    find . -name "*.pyc" -exec rm -rf {} \;
}

function remove-trailing-spaces-in-py-files {
    # Trim trailing spaces at end of line
    perl -pi -e "s/ +$//" **/*.py
    # Delete empty lines at end of file
    # perl -i -pe "chomp if eof" **/*.py
}

function git-amend-last-commit-set-date-to-now {
    GIT_COMMITTER_DATE="`date`" git commit --amend --date "`date`"
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
        if ssh-add -l 2>&1 > /dev/null; then
            echo "Found working SSH Agent: ${SSH_AUTH_SOCK}"
            ssh-add -L
            return
        fi
    done
    echo "Cannot find ssh agent - maybe you should reconnect and forward it?"
}

function f {
    # grep is for coloring in the output
    find ./ -iname "*$1*" -print | grep $1
}

psg ()
{
    ps aux | grep --color=auto $1
}

function psaux {
if [[ -n "$1" ]];then
    ps aux | head -1 && ps aux | grep "$1" | grep -v grep
else
    echo 'You must supply a grep search expression!'
fi
}

# Make it easier to search ZSH documentation
zman() {
    PAGER="less -g -s '+/^       "$1"'" man zshall
}

function whattoalias() {
  history|awk '{print $2}'|awk 'BEGIN {FS="|"} {print $1}'|sort|uniq -c|sort -n|tail -n10
}
