psg () 
{
    ps aux | grep --color=auto $1
}

# (f)ind by (n)ame
# usage: fn foo 
# to find all files containing 'foo' in the name
function fn() { ls **/*$1* }
