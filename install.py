#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import errno
import logging
import os
import platform

REPOSITORY = "https://github.com/charlax/dotfiles.git"
DOTFILES_PATH = os.path.join(os.environ["HOME"], ".dotfiles")
CONFIGURATION_FILES = (
    ("config/pudb/pudb.cfg", ".config/pudb/pudb.cfg"),
    "ctags/ctags",
    "git/gitignore",
    "git/gitconfig",
    "git/gitconfig.local",
    "hg/hgrc",
    "latex/latexmkrc",
    ("ssh/rc", ".ssh/rc"),
    "system/colors/dir_colors",
    "tmux/tmux.conf",
    ("virtualenvs/postmkvirtualenv", ".virtualenvs/"),
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


def create_folder(dest):
    """Create folder if not exists."""
    if os.path.exists(dest):
        return
    print "Folder %s does not exist, creating" % dest
    os.makedirs(dest)


def symlink_configuration_file(f, dest=None, force=False, base_path=None):
    """Symlink a configuration to ~."""
    if base_path:
        if base_path == '.':
            source_base_path = '.dotfiles'
        else:
            source_base_path = os.path.join(base_path, '.dotfiles')
    else:
        source_base_path = DOTFILES_PATH

    dest_base_path = base_path or os.environ["HOME"]
    source = os.path.join(source_base_path, f)

    if not dest:
        dest = os.path.join(dest_base_path, "." + os.path.basename(f))
    else:
        dest = os.path.join(dest_base_path, dest)

    print "Will link %s to %s" % (source, dest)

    create_folder(os.path.dirname(dest))

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
        os.system("./install/oxs_install.sh")

        print "You might want to run osx_config.sh in the dotfiles repo."
        print "You need to add zsh to /etc/shells and then run:"
        print "$ sudo sh -c 'echo \"/usr/local/bin/zsh\" >> /etc/shells' && chsh -s /usr/local/bin/zsh"

    elif system == "Linux":
        os.system("sudo apt-get update")
        os.system("sudo apt-get install -q -y silversearcher-ag zsh coreutils wget")
        print "Changing default shell"
        os.system("sudo chsh -s /bin/zsh $USER")

    # Generate markdown table of content
    os.system("npm install -g doctoc")


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
            symlink_configuration_file(*f,
                                       base_path=args.symlink_base,
                                       force=args.symlink_force)
        else:
            symlink_configuration_file(f,
                                       base_path=args.symlink_base,
                                       force=args.symlink_force)


def main(args):
    """Install the dotfiles."""
    # Must install before symlinking. Otherwise, some directory would
    # not exist, in particular ~/.virtualenvs
    clone_dotfile(REPOSITORY, DOTFILES_PATH)
    symlink(args)

    # We need to symlink before installing other software, because
    # installing other software has a higher probability to fail.
    if args.install:
        install_software()

    if args.with_dotvim:
        print "Installing dotvim..."
        os.system("curl https://raw.githubusercontent.com/charlax/dotvim/master/install.py -o install_dotvim.py")  # noqa
        os.system("python install_dotvim.py")
        os.remove("install_dotvim.py")

    print "Install complete."


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install charlax's dotfiles.")
    parser.add_argument("--with-dotvim", action="store_true",
                        help="Also install charlax's dotvim repository")
    parser.add_argument("--install", action="store_true",
                        help="Also install sofware")
    parser.add_argument("--symlink-force", "-f", action="store_true",
                        help="Force symlink the files")
    parser.add_argument("--symlink-base",
                        help="Base path for symlinks")
    args = parser.parse_args()

    main(args)
