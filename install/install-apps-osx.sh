set -e
unset -v

brew update > /dev/null


echo ""
echo "Installing:"
echo ""
echo "arp-scan: ARP scanner"
echo "cheat: cheatsheets for commands"
echo "docker completion"
echo "editorconfig"
echo "fswatch: watch for file changes"
echo "gdb: debugger"
echo "httpie: CLI http client"
echo "jq: json formatting"
echo "ncdu: ncurses disk usage"
echo "rg: file searching"
echo "the_silver_searcher: file searching (ag command)"
echo "tldr: simplified and community-driven man pages"
echo ""

brew install \
    arp-scan \
    autojump \
    automake  \
    bat \  # A cat(1) clone with wings.
    cheat \
    coreutils \
    docker-completion \
    docker-compose-completion \
    docker-machine-completion \
    dos2unix \
    editorconfig \
    exa \  # A modern replacement for ls.
    fd \  # A simple, fast and user-friendly alternative to 'find'
    findutils \
    fswatch \
    fzf \
    git \
    go \
    hexyl \  # A command-line hex viewer
    highlight \
    httpie \
    hub \
    jq \
    miller \
    mysql \
    ncdu \
    node \
    python \
    python3 \
    rg \
    rmtrash \
    telnet \
    the_silver_searcher \
    tldr \
    tmux \
    unrar \
    watchexec \  # Executes commands in response to file modifications
    wget \
    yarn \
    zsh \
    zsh-completions


echo ""
echo "Installing fzf shell bindings"
/usr/local/opt/fzf/install
