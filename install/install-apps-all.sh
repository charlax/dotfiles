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
    # Optional
    # john-jumbo       # john the ripper

    packages=(arp-scan   # ARP scanner
        automake
        bat              # A cat(1) clone with wings https://github.com/sharkdp/bat
        cheat            # cheatsheets for commands
        coreutils
        ctags
        docker-completion
        dos2unix
        editorconfig
        exa              # modern replacement for ls https://the.exa.website/
        fd               # alternative to 'find' https://github.com/sharkdp/fd
        findutils
        fswatch          # watch for file changes
        fzf              # fuzzy finder https://github.com/junegunn/fzf
        git
        gnupg
        hashcat          # advanced pasword recovery
        hexyl            # hex viewer https://github.com/sharkdp/hexyl
        highlight
        htop             # process viewer https://htop.dev/
        httpie           # CLI http client
        jq               # json formatting
        macvim
        make             # newer Makefile
        miller           # like awk, sed, cut, join, and sort for CSV, TSV, and tabular JSON https://github.com/johnkerl/miller
        mysql
        ncdu             # ncurses disk usage https://dev.yorhel.nl/ncdu
        nmap             # port scanner
        node
        openvpn          # vpn
        pandoc
        pinentry-mac     # Use Keychain for GPG (Mac-only)
        python
        python3
        redis
        rename           # mass rename
        rg               # ripgrep, fast file searching https://github.com/BurntSushi/ripgrep
        rmtrash
        shellcheck       # static analysis for shell scripts
        shfmt            # shell parser, formatter, and interpreter https://github.com/mvdan/sh
        telnet
        tldr             # simplified and community-driven man pages
        tmux             # terminal multiplexer
        tree             # display file list in tree
        wget
    )

    log_info "Updating brew"

    brew update > /dev/null

    log_info "Installing brew packages"

    brew update
    brew install "${packages[@]}"

    printf "\nInstalling fzf shell bindings"
    /usr/local/opt/fzf/install

    brew tap homebrew/cask-fonts

    apps=(1password
        adobe-acrobat-reader
        # adoptopenjdk8  unavailable??
        alfred
        calibre
        discord
        docker
        google-chrome
        firefox
        font-roboto-nerd-font
        homebrew/cask-versions/google-chrome-canary
        iterm2
        libreoffice
        mactex
        openvpn-connect
        postman
        rectangle           # window management
        sequel-pro
        spotify
        transmission
        typora
        vagrant             # useful for installing kali
        visual-studio-code
        vlc
        whatsapp
        wireshark
        zettlr              # Zettlekasten method
        )

    brew install --cask "${apps[@]}"

    # Specify the preferences directory
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$DOTFILES/iterm"
    # Tell iTerm2 to use the custom preferences in the directory
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

    rectangle_config="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"
    if [ ! -L "$rectangle_config" ]; then
      log_info "Overwriting Rectangle shortcuts with link to dotfiles ones."
      [ -e "$rectangle_config" ] && mv "$rectangle_config" "$HOME/Downloads/SpectacleShortcuts.bak.json"
      ln -s "$DOTFILES/rectangle/com.knollsoft.Rectangle.plist" "$rectangle_config"
    fi
}

function install_apt_packages {
    local tmp_dir
    local packages

    log_info "Installing apt packages"

    # TODO: move most of this to install-apps-all

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
        pipx            # install Python applications in environments
        python3-pip
        python3-venv
        ripgrep         # recursively searches dir for a regex pattern
        shellcheck      # static analysis for shell scripts
        ssh
        strace
        tldr            # quick summary of CLI commands
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

    if [ "$OSTYPE" = "linux-gnu" ] && ! command -v brew &> /dev/null; then
        echo "Installing homebrew"
        CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    # Optional:

    # brew tap lucagrulla/tap # for cw

    # asciinema              # record CLI session
    # asdf                   # manage multiple versions of node, etc.
    # awscli                 # AWS command line
    # azure-cli              # Azure command line
    # binwalk                # inspect files
    # cloc                   # count lines of code
    # ctop                   # htop for docker container https://github.com/bcicen/ctop
    # cw                     # AWS cloudwatch logs
    # gh                     # Github cli
    # gnu-sed                # GNU sed
    # hexyl                  # command-line hex viewer
    # hyperfine              # benchmark took https://github.com/sharkdp/hyperfine
    # imagemagick            # convert images
    # leiningen              # automate Clojure projects
    # nvim                   # neovim
    # sqlmap                 # sql injection tool
    # terraform              # infrastructure management
    # tokei                  # cloc https://github.com/XAMPPRocky/tokei
    # veeso/termscp/termscp  # terminal UI file transfer (e.g. sftp) https://veeso.github.io/termscp

    packages=(bandwhich # bandwith utilization https://github.com/imsnif/bandwhich
        broot           # better tree https://github.com/Canop/broot
        csvq            # query csv from command line
        dust            # better du https://github.com/bootandy/dust
        fastmod         # multifile search and replace https://github.com/facebookincubator/fastmod
        git-delta       # better diff viewer https://github.com/dandavison/delta
        go              # golang
        pipx            # install and run python applications in environments
        procs           # modern ps, experimental support for macos https://github.com/dalance/procs
        renameutils     # imv (faster rename) etc.
        sd              # intuitive find & replace cli, kind of like sed https://github.com/chmln/sd
        starship        # command line prompt https://starship.rs/
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

function install_pipx_packages {
    log_info "Installing Python software with pipx"

    # Optional

    # wfuzz        # the web fuzzer

    pipx_packages=(
        glances      # htop alternative
        ipython      # better python console
        poetry       # package management
        pre-commit   # pre-commit hooks
        vim-vint     # vimscript linter
        yq           # jq for YAML, XML, TOML
    )

    set -o verbose
    for package in "${pipx_packages[@]}"; do
        pipx install --force "$package"
    done
    set +o verbose
}

function install_pipenv {
    log_info "Installing pipenv"
    pip install --user pipenv
}


function update_all {
    log_info "Running update script to install the rest"
    update-everything
}

# For poetry autocompletions
mkdir ~/.zfunc

install_brew_packages
install_vim
install_pipx_packages
install_pipenv
update_all

log_info "Done. If this is a fresh install, you might want to logout/login"
