#!/usr/bin/python
# -*- coding: utf-8 -*-

import argparse
import logging
import os
import platform

DOTFILES_PATH = os.path.join(os.environ["HOME"], ".dotfiles")
REPOSITORY = "git@github.com:charlax/dotfiles.git"
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


def install(args):
    """Install the dotfiles."""

    os.system("git clone %s ~/.dotfiles" % REPOSITORY)

    for f in CONFIGURATION_FILES:
        symlink_configuration_file(f)

    system = platform.system()

    if system == "Darwin":
        os.system("brew update")
        os.system("brew install -U ack zsh git coreutils zsh-completions rmtrash")
        os.system("sh %s/osx_config.sh" % DOTFILES_PATH)

        print "You need to add zsh to /etc/shells and then run:"
        print "$ chsh -s /usr/local/bin/zsh"

    elif system == "Linux":
        os.system("sudo aptitude update")
        os.system("sudo aptitude install ack-grep zsh coreutils")
        os.system("chsh -s /bin/zsh")

    if args.with_dotvim:
        print "Installing dotvim..."
        os.system("curl https://raw.github.com/charlax/dotvim/master/install.py -o- | python")

    print "Install complete."


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install charlax's dotfiles.")
    parser.add_argument("--with-dotvim", action="store_true",
            help="Also install charlax's dotvim repository")
    args = parser.parse_args()

    install(args)
