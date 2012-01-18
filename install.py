#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import logging

DOTFILES_PATH = os.path.join(os.environ["HOME"], ".dotfiles")

CONFIGURATION_FILES = ["zsh/zshrc", "git/gitignore", "git/gitconfig",
        "latex/latexmkrc"]

def symlink_configuration_file(f):
    """Symlink a configuration to ~
    """
    source = os.path.join(DOTFILES_PATH, f)
    target = os.path.join(os.environ["HOME"], "." + os.path.basename(f))

    if os.path.islink(target) or os.path.exists(target):
        logging.error("%s exists" % target)
    else:
        os.symlink(source, target)
        logging.info("%s symlinked to %s" % (source, target))

def install():
    for f in CONFIGURATION_FILES:
        symlink_configuration_file(f)

def main():
    install()
    os.system("chflags nohidden ~/Library/")

if __name__ == "__main__":
    main()
