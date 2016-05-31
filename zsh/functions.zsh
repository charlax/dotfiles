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

# (f)ind by (n)ame
# usage: fn foo
# to find all files containing 'foo' in the name
function fn() { ls **/*$1* }

# Make it easier to search ZSH documentation
zman() {
    PAGER="less -g -s '+/^       "$1"'" man zshall
}

function whattoalias() {
  history|awk '{print $2}'|awk 'BEGIN {FS="|"} {print $1}'|sort|uniq -c|sort -n|tail -n10
}
