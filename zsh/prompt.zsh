#!/usr/local/bin/zsh

if $(whence starship > /dev/null); then
    eval "$(starship init zsh)"
fi

# Set tab title for iTerm
function precmd() {
    if [[ -z "$TAB_TITLE" ]]; then
        # Set the tab title to current dir
        echo -ne "\e]1;${PWD##*/}\a"
    else
        echo -ne "\e]1;${TAB_TITLE}\a"
    fi
}

function settitle() {
    TAB_TITLE="$*"
}
