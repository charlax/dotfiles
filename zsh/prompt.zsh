# Thanks to oh-my-zsh

# Get the name of the branch we are on
function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "(${ref#refs/heads/}$(parse_git_dirty))"
}

# Checks if working tree is dirty
parse_git_dirty() {
    local SUBMODULE_SYNTAX="--ignore-submodules=dirty"

    if [[ -n $(git status -s ${SUBMODULE_SYNTAX}  2> /dev/null) ]]; then
        echo "✖"
    else
        echo ""
    fi
}

# Prompt
function precmd() {
    export PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}$(git_prompt_info)%. %{$reset_color%}%% "
}
