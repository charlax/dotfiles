#!/usr/bin/env bash

# shellcheck source=./helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh"

set -e
unset -v

function install_os_packages {
    log_info "Installing OS-specific packages"

    current_dir=$(dirname "$0")

    case "$OSTYPE" in
        "linux-gnu")
            "$current_dir"/install-apps-linux.sh
            ;;

        "darwin19")
            "$current_dir"/install-apps-osx.sh
            "$current_dir"/install-ui-apps-osx.sh
            ;;
    esac
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

    # asciinema       # record CLI session
    # asdf            # manage multiple versions of node, etc.
    # awscli          # AWS command line
    # binwalk         # inspect files
    # cloc            # count lines of code
    # ctop            # htop for container https://github.com/bcicen/ctop
    # cw              # AWS cloudwatch logs
    # gh              # Github cli
    # hexyl           # command-line hex viewer
    # hyperfine       # benchmark took https://github.com/sharkdp/hyperfine
    # leiningen       # automate Clojure projects
    # nvim            # neovim
    # sqlmap          # sql injection tool
    # terraform       # infrastructure management
    # tokei           # cloc https://github.com/XAMPPRocky/tokei

    packages=(bandwhich # bandwith utilization https://github.com/imsnif/bandwhich
        broot           # better tree https://github.com/Canop/broot
        csvq            # query csv from command line
        dust            # better du https://github.com/bootandy/dust
        fastmod         # multifile search and replace https://github.com/facebookincubator/fastmod
        procs           # modern ps, experimental support for macos https://github.com/dalance/procs
        renameutils     # imv (faster rename) etc.
        sd              # intuitive find & replace cli, kind of like sed https://github.com/chmln/sd
        starship        # command line prompt https://starship.rs/
        zoxide          # smarter cd command https://github.com/ajeetdsouza/zoxide
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

install_os_packages
install_brew_packages
install_vim
install_pipx_packages
install_pipenv
update_all

log_info "Done. If this is a fresh install, you might want to logout/login"
