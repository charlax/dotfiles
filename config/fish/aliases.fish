# Fish shell aliases
# Converted from system/aliases.zsh and zsh/aliases.zsh

# Reload fish configuration
alias reload_fish='source ~/.config/fish/config.fish'

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ls aliases (using eza if available)
if command -v eza > /dev/null
    alias ls='eza'
    alias l='eza -l'
    alias ll='eza -lh'
    alias la='eza -a'
else if command -v gls > /dev/null
    alias ls='gls -hF --color'
    alias l='gls -lAh --color'
    alias ll='gls -lh --color'
    alias la='gls -A --color'
else
    alias ls='ls --color=auto -hF'
    alias l='ls -lAh --color'
    alias ll='ls -lh --color'
    alias la='ls -A --color'
end

# Kubectl
if command -v kubectl > /dev/null
    alias k='kubectl'
end

# Find file
alias f='findfile'

# Text editors
alias m='edit'
alias e='edit'
alias v='vim'
alias vr='mvim'
alias nv='nvim'
alias mr='mvim'
alias vscode='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
alias edit-dotfiles='$EDITOR $DOTFILES'

# Utilities
alias tf='tail -f'
alias ka9='killall -9'
alias k9='kill -9'
alias grep='grep --color=auto'

# Git aliases
alias ga='git add'
alias gp='git push'
alias gl='git l'
alias gs='git status'
alias gd='git diff'
alias gdca='git diff --cached'
alias gds='git diff --staged'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gcma='git commit -am'
alias gcam='git commit -am'
alias gc='git checkout'
alias gr='git commit --amend'
alias gra='git add . && git commit --amend'
alias grm='git rebase master'
alias gpu='git pull'
alias gcl='git clone'
alias grepush='git recommit && git push -f'
alias gsp='git stash && git pull && git stash pop'
alias gpgp='git pull && git push'
alias gpushcurrent='git push -u origin HEAD'
alias gogo='git-done'
alias gg='git-done'

# Python
alias p='ipython'
alias p3='python3'
alias python='python3'
alias pypi_submit='python setup.py register sdist bdist upload'
alias venv='python -m venv'
alias serve='python3 -m http.server'
alias pydoc='python -m pydoc'
alias pdb='python -m ipdb'
alias pytime='python -m timeit'
alias pyprof='python -m profile'
alias jcat='python -m json.tool'
alias cal='python -m calendar'
alias pprint='python -c "import pprint, sys, ast; pprint.pprint(ast.literal_eval(sys.stdin.read()))"'

# ctags
alias ctg='g -l --python . | ctags -L - -f tags'
alias ctag='ctg'

# Other tools
alias timestamp='date +%s'
alias timestamp_ms='python -c "import time; print(int(time.time() * 1000))"'
alias generate_secret='openssl rand -base64 32'

# Directory shortcuts
alias d='cd ~/Downloads'
alias checkout='cd ~/Downloads && m '
alias br='broot'

# macOS specific
if test (uname) = Darwin
    alias chrome='open -a "Google Chrome"'
    alias firefox='open -a "Firefox"'
    alias ff='firefox'
    alias iawriter='open -a "IA Writer"'
    alias iar='iawriter README*'
end
