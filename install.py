#!/usr/bin/python
# -*- coding: utf-8 -*-

import argparse
import logging
import os
import platform

DOTFILES_PATH = os.path.join(os.environ["HOME"], ".dotfiles")
REPOSITORY = "git://github.com/charlax/dotfiles.git"
CONFIGURATION_FILES = ["zsh/zshrc", "git/gitignore", "git/gitconfig",
        "latex/latexmkrc", "ctags/ctags", "ack/ackrc"]


def symlink_configuration_file(f):
    """Symlink a configuration to ~."""

    source = os.path.join(DOTFILES_PATH, f)
    target = os.path.join(os.environ["HOME"], "." + os.path.basename(f))

    if os.path.islink(target) or os.path.exists(target):
        logging.error("%s exists" % target)
    else:
        os.symlink(source, target)
        logging.info("%s symlinked to %s" % (source, target))


def install_software():
    """Install software."""

    system = platform.system()

    if system == "Darwin":
        os.system("brew update")
        os.system("brew install -U ack zsh git coreutils zsh-completions "
                " rmtrash automake wget")
        os.system("sh %s/osx_config.sh" % DOTFILES_PATH)

        print "You need to add zsh to /etc/shells and then run:"
        print "$ chsh -s /usr/local/bin/zsh"

    elif system == "Linux":
        os.system("sudo apt-get update")
        os.system("sudo apt-get install -q -y ack-grep zsh coreutils wget")
        os.system("chsh -s /bin/zsh")

    os.system("sudo easy_install pip")
    os.system("sudo pip install virtualenv virtualenvwrapper autopep8")

    if args.with_dotvim:
        print "Installing dotvim..."
        os.system("curl https://raw.github.com/charlax/dotvim/master/install.py -o install_dotvim.py")
        os.system("python install_dotvim.py")
        os.remove("install_dotvim.py")


def clone_dotfile():
    """Clone or update the dotfiles directory."""

    if not os.path.exists(DOTFILES_PATH):
        os.system("git clone %s %s" % (REPOSITORY, DOTFILES_PATH))
    else:
        os.system("cd %s && git checkout master && git pull" % DOTFILES_PATH)

    if not os.path.exists(DOTFILES_PATH):
        raise Exception("Dotfiles path '%s' does not exist" % DOTFILES_PATH)


def install(args):
    """Install the dotfiles."""

    clone_dotfile()

    for f in CONFIGURATION_FILES:
        symlink_configuration_file(f)

    if not args.only_symlink:
        install_software()

    print "Install complete."


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install charlax's dotfiles.")
    parser.add_argument("--with-dotvim", action="store_true",
            help="Also install charlax's dotvim repository")
    parser.add_argument("--only-symlink", action="store_true",
            help="Only symlink the files")
    args = parser.parse_args()

    install(args)
