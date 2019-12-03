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
    cheat \
    coreutils \
    docker-completion \
    docker-compose-completion \
    docker-machine-completion \
    dos2unix \
    editorconfig \
    findutils \
    fswatch \
    fzf \
    git \
    go \
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
    wget \
    yarn \
    zsh \
    zsh-completions


echo ""
echo "Installing fzf shell bindings"
/usr/local/opt/fzf/install

echo ""
echo "Running update script to install the rest"
update-everything.sh

echo ""
echo "Installing pipx"
python3 -m pip install --user pipx
python3 -m userpath append ~/.local/bin

echo ""
echo "Installing glances, an htop alternative"
pipx install glances
