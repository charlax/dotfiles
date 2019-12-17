set -e
unset -v

brew update > /dev/null


echo ""
echo "Installing software"
echo ""

brew install \
    arp-scan \  # ARP scanner
    autojump \
    automake  \
    awsebcli \  # utils for AWS
    bat \       # A cat(1) clone with wings.
    cheat \     # cheatsheets for commands
    coreutils \
    docker-completion \
    docker-compose-completion \
    docker-machine-completion \
    dos2unix \
    editorconfig \
    exa \       # A modern replacement for ls.
    fd \        # A simple, fast and user-friendly alternative to 'find'
    findutils \
    fswatch \   # watch for file changes
    fzf \
    git \
    go \
    hexyl \     # A command-line hex viewer
    highlight \
    httpie \    # CLI http client
    hub \
    jq \        # json formatting
    john-jumbo \ # john the ripper
    miller \
    mysql \
    ncdu \      # ncurses disk usage
    node \
    python \
    python3 \
    redis  \
    rg \        # file searching
    rmtrash \
    telnet \
    the_silver_searcher \ # file searching (ag command)
    tldr \      # simplified and community-driven man pages
    tmux \
    tree \      # display file list in tree
    unrar \
    watchexec \  # Executes commands in response to file modifications
    wget \
    yarn \
    zsh \
    zsh-completions


echo ""
echo "Installing fzf shell bindings"
/usr/local/opt/fzf/install
