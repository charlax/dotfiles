#!/usr/bin/env bash

# shellcheck source=./helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

APT_GET="apt-get -qq -y"
current_dir=$(dirname "$0")

set -e
unset -v

function set_default_shell() {
    local default_shell
    default_shell=$(grep "^$(id -un):" /etc/passwd | cut -d : -f 7-)
    if ! [[ "$default_shell" =~ "zsh" ]]; then
        log_info "Changing default shell"
        # Works on AWS Ubuntu
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        sudo chsh -s "$(which zsh)" "$(whoami)"
        # chsh --shell /usr/bin/zsh

        log_info "Default shell changed, this will take effect only after login/logout"
    fi
}

function install_osx_packages {
    local packages
    local apps

    log_info "install_osx_packages"

    # Optional
    # john-jumbo       # john the ripper
    # mysql
    # redis

    packages=(arp-scan   # ARP scanner
        automake
        bat              # A cat(1) clone with wings https://github.com/sharkdp/bat
        cheat            # cheatsheets for commands https://github.com/cheat/cheat
        coreutils
        ctags
        dos2unix
        duti             # define default app on macOS https://github.com/moretension/duti
        editorconfig
        eza              # modern replacement for ls https://github.com/eza-community/eza
        fish             # modern shell https://fishshell.com/
        fd               # alternative to 'find' https://github.com/sharkdp/fd
        findutils
        fswatch          # watch for file changes
        fzf              # fuzzy finder https://github.com/junegunn/fzf
        git
        gnupg
        hashcat          # advanced password recovery
        hexyl            # hex viewer https://github.com/sharkdp/hexyl
        highlight
        htop             # process viewer https://htop.dev/
        httpie           # CLI http client
        jq               # json formatting
        maccy            # clipboard history https://github.com/p0deje/Maccy
        macvim           # text editor
        make             # newer Makefile
        miller           # like awk, sed, cut, join, and sort for CSV, TSV, and tabular JSON https://github.com/johnkerl/miller
        ncdu             # ncurses disk usage https://dev.yorhel.nl/ncdu
        nmap             # port scanner
        node
        openvpn          # vpn
        pandoc
        pinentry-mac     # Use Keychain for GPG (Mac-only)
        python
        python3
        rename           # mass rename
        rg               # ripgrep, fast file searching https://github.com/BurntSushi/ripgrep
        shellcheck       # static analysis for shell scripts
        shfmt            # shell parser, formatter, and interpreter https://github.com/mvdan/sh
        telnet
        tmux             # terminal multiplexer
        trash            # move files to the trash
        tree             # display file list in tree
        wget
    )

    log_info "Updating brew"

    brew update > /dev/null

    log_info "Installing brew packages for macOS"

    brew update
    brew install "${packages[@]}"

    printf "\nInstalling fzf shell bindings"
    [[ -e /usr/local/opt/fzf/install ]] && /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc
    [[ -e /opt/homebrew/opt/fzf/install ]] && /opt/homebrew/opt/fzf/install --key-bindings --completion --no-update-rc

    brew tap espanso/espanso

    # Do not install macvim as a cask (to automatically install Python3)

    # 1password
    # adoptopenjdk8  unavailable??
    # calibre
    # discord
    # docker (check if installed, not for large companies)
    # google-chrome (check if installed)
    # homebrew/cask-versions/google-chrome-canary
    # libreoffice
    # mactex
    # openvpn-connect
    # postman
    # sequel-pro
    # vagrant             # useful for installing kali - requires Rosetta 2

    apps=(anki               # flash cards
        # adobe-acrobat-reader # necessary for some docs
        espanso              # text expander
        firefox              # browser
        font-roboto-mono-nerd-font
        ghostty              # terminal
        kitty                # terminal
        neovide              # neovim GUI
        pritunl              # open source VPN client
        rectangle            # window management
        shottr               # screenshot tool
        # spotify              # music
        visual-studio-code   # text editor
        vlc                  # video player
        whatsapp
        wireshark            # network sniffer
        zettlr               # Zettlekasten method
        )

    log_info "Installing brew cask packages for macOS"
    if ! brew install --cask "${apps[@]}"; then
        log_info "Some apps failed to install (may already be installed)"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    log_info "Installing LSP servers via npm"
    npm install -g pyright
}

function install_apt_packages {
    local tmp_dir
    local packages

    log_info "Installing apt packages"

    # shellcheck disable=SC2086
    sudo DEBIAN_FRONTEND=noninteractive $APT_GET update > /dev/null

    # To add:
    # vscode
    # shutter # screenshot tool
    # peek    # screencast tool
    # peco    # simplistic interactive filtering tool

    # Optional:
    # neovim          # heavily refactored vim fork
    # gobuster        # busting tool
    # httpie          # http client

    packages=(dsniff    # includes arpspoof
        exuberant-ctags
        fzf             # fuzzy finder
        gdb             # GNU debugger
        golang          # Go programming language
        htop            # process managemenent
        jq              # json query
        pandoc
        python3-pip
        python3-venv
        ripgrep         # recursively searches dir for a regex pattern
        shellcheck      # static analysis for shell scripts
        ssh
        strace
        tmux            # terminal multiplexer
        tree            # ls in a tree
        vim-nox         # Vim with scripting support
        xclip           # Linux command line clipboard grabber
        zsh
    )

    # shellcheck disable=SC2086
    sudo $APT_GET install "${packages[@]}" > /dev/null

    tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
    packages=(libreoffice
        slack-desktop
        vagrant
        vim-gtk3
        wireshark
    )

    # shellcheck disable=SC2086
    sudo $APT_GET install "${packages[@]}" > /dev/null

    IS_CHROME_INSTALLED=$(dpkg-query -W --showformat='${Status}\n' google-chrome-stable|grep "install ok installed")

    if [[ "$IS_CHROME_INSTALLED" == "" ]]; then
        log_info "Installing Google Chrome"
        chrome_file="$tmp_dir/google-chrome.deb"
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O "$chrome_file"
        sudo dpkg -i "$chrome_file"
    fi
}

function install_brew_packages {
    log_info "Installing common brew packages"

    echo "You might need to run a command with sudo first, like sudo ls"

    if [ "$OSTYPE" = "linux-gnu" ] && ! command -v brew &> /dev/null; then
        echo "Installing homebrew"
        CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    # Optional:

    # brew tap lucagrulla/tap # for cw

    # asciinema       # record CLI session
    # asdf            # manage multiple versions of node, etc.
    # awscli          # AWS command line
    # azure-cli       # Azure command line
    # clojure         # the programming language
    # ctop            # htop for docker container https://github.com/bcicen/ctop
    # cw              # AWS cloudwatch logs
    # hyperfine       # benchmark took https://github.com/sharkdp/hyperfine
    # leiningen       # automate Clojure projects
    # neovim          # neovim
    # rustup          # rust toolchain, then run rustup-init
    # sqlmap          # sql injection tool
    # terraform       # infrastructure management
    # veeso/termscp/termscp  # terminal UI file transfer (e.g. sftp) https://veeso.github.io/termscp

    packages=(bandwhich # bandwith utilization https://github.com/imsnif/bandwhich
        binwalk         # inspect files
        broot           # better tree https://github.com/Canop/broot
        cloc            # count lines of code
        csvq            # query csv from command line
        difftastic      # diff tool https://difftastic.wilfred.me.uk/git.html
        dust            # better du https://github.com/bootandy/dust
        fastmod         # multifile search and replace https://github.com/facebookincubator/fastmod
        gawk            # GNU awk
        git-delta       # better diff viewer https://github.com/dandavison/delta
        gnu-sed         # GNU sed
        gh              # Github cli
        go              # golang
        hexyl           # command-line hex viewer
        imagemagick     # convert images
        k9s             # monitor kubernetes
        mitmproxy       # proxy https://mitmproxy.org/
        procs           # modern ps, experimental support for macos https://github.com/dalance/procs
        renameutils     # imv (faster rename) etc.
        sd              # intuitive find & replace cli, kind of like sed https://github.com/chmln/sd
        starship        # command line prompt https://starship.rs/
        tokei           # cloc https://github.com/XAMPPRocky/tokei
        uv              # Python package manager
        yarn            # required for installing coc extensions
        zoxide          # smarter cd command https://github.com/ajeetdsouza/zoxide
        zsh
        zsh-completions
        )

    brew update
    brew install "${packages[@]}"
}

function install_vim {
    log_info "Installing vim"
    "$current_dir/install-vim.sh"
}

function update_all {
    log_info "Running update script to install the rest"
    update-everything
}

# For poetry autocompletions
mkdir -p ~/.zfunc

if [[ "$OSTYPE" == "darwin"* ]]; then
    install_osx_packages
fi

install_brew_packages
install_vim
update_all

log_info "Done. If this is a fresh install, you might want to logout/login"
