#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import errno
import logging
import os

REPOSITORY = "https://github.com/charlax/dotfiles.git"
DOTFILES_PATH = os.path.join(os.environ["HOME"], ".dotfiles")
CONFIGURATION_FILES = (
    ("config/pudb/pudb.cfg", ".config/pudb/pudb.cfg"),
    ("config/fish/config.fish", ".config/fish/config.fish"),
    "ctags/ctags",
    "ghci/ghci",
    "git/gitignore",
    "git/gitconfig",
    "git/gitconfig.local",
    "hg/hgrc",
    "latex/latexmkrc",
    ("ssh/rc", ".ssh/rc"),
    ("ssh/config", ".ssh/config"),
    "system/colors/dir_colors",
    "tmux/tmux.conf",
    ("virtualenvs/postmkvirtualenv", ".virtualenvs/"),
    "zsh/zshrc",
    "zsh/zshenv",
)


def run(cmd: str) -> int:
    r = os.system(cmd)
    if r != 0:
        raise OSError(f"{cmd} returned non-zero status: {r}")
    return r


def force_symlink(src, dest):
    """Force symlink a file."""
    try:
        os.symlink(src, dest)
    except OSError as e:
        if e.errno == errno.EEXIST:
            os.remove(dest)
            os.symlink(src, dest)


def create_folder(dest):
    """Create folder if not exists."""
    if os.path.exists(dest):
        return
    print("Folder %s does not exist, creating" % dest)
    os.makedirs(dest)


def symlink_configuration_file(
    f, dest=None, force=False, base_path=None, dry_run=False
):
    """Symlink a configuration to ~."""
    dest_base_path = base_path or os.environ["HOME"]

    # Source is where the dotfiles are installed, it's always relative
    # to where the files will be installed.
    source_base_path = os.path.join(dest_base_path, ".dotfiles")
    source = os.path.join(source_base_path, f)

    if not dest:
        dest = os.path.join(dest_base_path, "." + os.path.basename(f))
    else:
        dest = os.path.join(dest_base_path, dest)

    if dry_run:
        print("Would symlink %s to %s" % (source, dest))
        return

    create_folder(os.path.dirname(dest))

    if not force and (os.path.islink(dest) or os.path.exists(dest)):
        print("Not symlinking '%s': already exists." % dest)
        return

    print("Symlinking '%s' -> '%s'." % (source, dest))
    if not force:
        try:
            os.symlink(source, dest)
        except OSError as e:
            print("Could not symlink %s: %r" % (source, e))
    else:
        force_symlink(source, dest)
    logging.info("%s symlinked to %s" % (source, dest))


def clone_dotfile(repo, path):
    """Clone or update the dotfiles directory."""
    if os.path.exists(path):
        return

    run("git clone %s %s" % (repo, path))

    if not os.path.exists(path):
        raise Exception("Dotfiles path '%s' does not exist" % path)


def symlink(args):
    """Symlink the files."""
    for f in CONFIGURATION_FILES:
        if isinstance(f, (tuple, list)):
            symlink_configuration_file(
                *f,
                base_path=args.symlink_base,
                force=args.symlink_force,
                dry_run=args.dry_run,
            )
        else:
            symlink_configuration_file(
                f,
                base_path=args.symlink_base,
                force=args.symlink_force,
                dry_run=args.dry_run,
            )


def main(args):
    """Install the dotfiles."""
    clone_dotfile(REPOSITORY, DOTFILES_PATH)
    symlink(args)

    if args.with_dotvim:
        print("Installing dotvim...")
        run(os.path.join(DOTFILES_PATH, "bin/install_vim_dotfiles.sh"))

    print("Install complete.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install charlax's dotfiles.")
    parser.add_argument(
        "--with-dotvim",
        action="store_true",
        help="Also install charlax's dotvim repository",
    )
    parser.add_argument(
        "--symlink-force", "-f", action="store_true", help="Force symlink the files"
    )
    parser.add_argument("--dry-run", action="store_true", help="Dry run")
    parser.add_argument("--symlink-base", help="Base path for symlinks, defaults to ~")

    args = parser.parse_args()

    main(args)
