#!/usr/bin/python
# -*- coding: utf-8 -*-

import argparse
import errno
import logging
import os
import platform

REPOSITORY = "git://github.com/charlax/dotfiles.git"
DOTFILES_PATH = os.path.join(os.environ["HOME"], ".dotfiles")
CONFIGURATION_FILES = (
    "ack/ackrc",
    "ctags/ctags",
    "git/gitignore",
    "git/gitconfig",
    "hg/hgrc",
    "latex/latexmkrc",
    ("pip/pip.conf", "~/.pip/pip.conf"),
    "system/colors/dir_colors",
    "tmux/tmux.conf",
    ("virtualenvs/postmkvirtualenv", "~/.virtualenvs/"),
    "zsh/zshrc",
)


def force_symlink(src, dest):
    """Force symlink a file."""
    try:
        os.symlink(src, dest)
    except OSError, e:
        if e.errno == errno.EEXIST:
            os.remove(dest)
            os.symlink(src, dest)


def symlink_configuration_file(f, dest=None, force=False):
    """Symlink a configuration to ~."""
    source = os.path.join(DOTFILES_PATH, f)

    if not dest:
        dest = os.path.join(os.environ["HOME"], "." + os.path.basename(f))
    else:
        f = os.path.basename(f)
        if dest.endswith("/"):
            dest = os.path.expanduser(dest) + f
        else:
            dest = os.path.expanduser(dest)

    if not force and (os.path.islink(dest) or os.path.exists(dest)):
        print "Not symlinking '%s': already exists." % dest
    else:
        print "Symlinking '%s' -> '%s'." % (source, dest)
        if not force:
            try:
                os.symlink(source, dest)
            except OSError as e:
                print "Could not symlink %s: %r" % (source, e)
        else:
            force_symlink(source, dest)
        logging.info("%s symlinked to %s" % (source, dest))


def install_software():
    """Install software."""
    print "Installing software..."

    system = platform.system()
    if system == "Darwin":
        # TODO: put this in a file, with comments about what each
        # software does.
        os.system("brew update")
        os.system("brew install -U ack zsh git coreutils zsh-completions "
                  "rmtrash automake wget mercurial git-flow "
                  "python python3 autojump hub unrar highlight "
                  "entr "
                  # JSON parser
                  "jq "
                  )

        print "You might want to run osx_config.sh in the dotfiles repo."
        print "You need to add zsh to /etc/shells and then run:"
        print "$ chsh -s /usr/local/bin/zsh"

    elif system == "Linux":
        os.system("sudo apt-get update")
        os.system("sudo apt-get install -q -y ack-grep zsh coreutils wget")
        print "Changing default shell"
        os.system("sudo chsh -s /bin/zsh $USER")

    print "Installing important Python packages"
    # pprintpp is used to pretty print Python structured on the cli
    os.system("sudo pip install virtualenv virtualenvwrapper flake8 httpie "
              "pprintpp")

    if args.with_dotvim:
        print "Installing dotvim..."
        os.system("curl https://raw.githubusercontent.com/charlax/dotvim/master/install.py -o install_dotvim.py")
        os.system("python install_dotvim.py")
        os.remove("install_dotvim.py")


def clone_dotfile(repo, path):
    """Clone or update the dotfiles directory."""
    if not os.path.exists(path):
        os.system("git clone %s %s" % (repo, path))
    else:
        os.system("cd %s && git checkout master && git pull" % path)

    if not os.path.exists(path):
        raise Exception("Dotfiles path '%s' does not exist" % path)


def symlink(args):
    """Symlink the files."""
    for f in CONFIGURATION_FILES:
        if isinstance(f, (tuple, list)):
            symlink_configuration_file(*f, force=args.symlink_force)
        else:
            symlink_configuration_file(f, force=args.symlink_force)


def main(args):
    """Install the dotfiles."""

    # Must install before symlinking. Otherwise, some directory would
    # not exist, in particular ~/.virtualenvs
    if not args.symlink_only:
        clone_dotfile(REPOSITORY, DOTFILES_PATH)
    symlink(args)

    # We need to symlink before installing other software, because
    # installing other software has a higher probability to fail.
    if not args.symlink_only:
        install_software()

    print "Install complete."


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install charlax's dotfiles.")
    parser.add_argument("--with-dotvim", action="store_true",
                        help="Also install charlax's dotvim repository")
    parser.add_argument("--symlink-only", "-s", action="store_true",
                        help="Only symlink the files")
    parser.add_argument("--symlink-force", "-f", action="store_true",
                        help="Force symlink the files")
    args = parser.parse_args()

    main(args)
