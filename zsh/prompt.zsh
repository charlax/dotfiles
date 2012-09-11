# Thanks to oh-my-zsh

export VIRTUAL_ENV_DISABLE_PROMPT='1'

# Get the name of the branch we are on
function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "(%{$fg[yellow]%}${ref#refs/heads/}%{$reset_color%}$(parse_git_dirty)) "
}

# Checks if working tree is dirty
parse_git_dirty() {
    local SUBMODULE_SYNTAX="--ignore-submodules=dirty"

    if [[ -n $(git status -s ${SUBMODULE_SYNTAX}  2> /dev/null) ]]; then
        echo "%{$fg[red]%}*%{$reset_color%}"
    else
        echo ""
    fi
}

# Get the name of virtual env
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# Prompt
function precmd() {
    export PS1="%{$fg[blue]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%} $(git_prompt_info)%{$fg[yellow]%}%. %{$reset_color%}$(virtualenv_info)%% "
}
