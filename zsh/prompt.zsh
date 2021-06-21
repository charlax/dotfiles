#!/usr/local/bin/zsh

eval "$(starship init zsh)"

# Prompt
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
