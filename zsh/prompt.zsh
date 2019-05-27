export VIRTUAL_ENV_DISABLE_PROMPT='1'

# Get the name of virtual env
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# Turn on command substitution in the prompt
setopt PROMPT_SUBST

zstyle ':vcs_info:*' disable bzr cdv darcs mtn svk tla
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats "(%{$fg[yellow]%}%b%{$reset_color%}%{$fg[red]%}%u%{$reset_color%}%{$fg[yellow]%}%c%{$reset_color%}) "
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '*'

# From vcs_info-examples
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

function +vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='*'
    fi
}

# Prompt
function precmd() {
    vcs_info

    if [[ -z "$TAB_TITLE" ]]; then
        # Set the tab title to current dir
        echo -ne "\e]1;${PWD##*/}\a"
    else
        echo -ne "\e]1;${TAB_TITLE}\a"
    fi

    export PROMPT="$prompt_newline%{$fg[blue]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%} \
${vcs_info_msg_0_}%{$fg[yellow]%}%. %{$reset_color%}$(virtualenv_info)\
%D{%L:%M}$prompt_newline%% "
}

function settitle() {
    TAB_TITLE="$*"
}
