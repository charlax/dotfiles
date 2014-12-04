# Found in http://chneukirchen.org/blog/archive/2012/02/10-new-zsh-tricks-you-may-not-know.html
#
# Make C-z on the command line resume vim again
foreground-vim() {
    fg %vi
}
zle -N foreground-vim
bindkey '^Z' foreground-vim

# Bind delete key to something meaningful like... deleting.
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char
