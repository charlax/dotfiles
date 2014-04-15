export VIRTUAL_ENV_DISABLE_PROMPT='1'

# Get the name of virtual env
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# Turn on command substitution in the prompt 
setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats "(%{$fg[yellow]%}%b%{$reset_color%}%{$fg[red]%}%u%{$reset_color%}%{$fg[yellow]%}%c%{$reset_color%}) "
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '*'

# Prompt
function precmd() {
    vcs_info
    export PROMPT="%{$fg[blue]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%} ${vcs_info_msg_0_}%{$fg[yellow]%}%. %{$reset_color%}$(virtualenv_info)%% "
}
