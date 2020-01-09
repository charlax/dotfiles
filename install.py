#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import errno
import logging
import os
import subprocess
from typing import List

import color

REPOSITORY = "https://github.com/charlax/dotfiles.git"
DOTFILES_PATH = os.path.join(os.environ["HOME"], ".dotfiles")

DOTVIM_REPOSITORY = "https://github.com/charlax/dotvim.git"
DOTVIM_PATH = os.path.join(os.environ["HOME"], ".vim")

CONFIGURATION_FILES = (
    ("config/pudb/pudb.cfg", ".config/pudb/pudb.cfg"),
    ("config/fish/config.fish", ".config/fish/config.fish"),
    ("config/cheat", ".config/cheat"),
    "ctags/ctags",
    "gdb/gdbinit",
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
    "zsh/zshrc",
    "zsh/zshenv",
)


def run(cmd: List[str], *args, **kwargs) -> int:
    kwargs.setdefault("check", True)
    return subprocess.run(cmd, *args, **kwargs)


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


def clone_or_update(repo, path):
    """Clone or update a repo."""
    if not os.path.exists(path):
        print(color.green("\nCloning dotfiles repo..."))
        run(["git", "clone", repo, path])

    try:
        print(color.green("\nUpdating dotfiles repo..."))
        run(["git", "pull"], cwd=path)
        run(["git", "submodule", "init"], cwd=path)
        run(["git", "submodule", "update"], cwd=path)
    except subprocess.CalledProcessError:
        print("WARNING git pull failed, continuing anyway, repo might be outdated")


def symlink(args):
    """Symlink the files."""
    print(color.green("\nSymlinking configuration files..."))
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


def run_settings():
    print(color.green("\nSettings things up..."))
    run(os.path.join(DOTFILES_PATH, "install/set-config-all.sh"))


def install_apps():
    print(color.green("\nInstall apps..."))
    run(os.path.join(DOTFILES_PATH, "install/install-apps-all.sh"))


def main(args):
    """Install the dotfiles."""
    clone_or_update(REPOSITORY, DOTFILES_PATH)
    symlink(args)

    if args.with_apps:
        install_apps()

    if args.with_dotvim:
        print("Installing dotvim...")
        clone_or_update(DOTVIM_REPOSITORY, DOTVIM_PATH)
        run(os.path.join(DOTVIM_PATH, "install.py"))

    if args.with_settings:
        run_settings()

    print("Install complete.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install charlax's dotfiles.")
    parser.add_argument(
        "--with-all", action="store_true", help="Also install dotvim and apps"
    )
    parser.add_argument(
        "--with-dotvim",
        action="store_true",
        help="Also install charlax's dotvim repository",
    )
    parser.add_argument("--with-apps", action="store_true", help="Also install apps")
    parser.add_argument(
        "--with-settings", action="store_true", help="Also run settings"
    )

    parser.add_argument(
        "--symlink-force", "-f", action="store_true", help="Force symlink the files"
    )
    parser.add_argument("--dry-run", action="store_true", help="Dry run")
    parser.add_argument("--symlink-base", help="Base path for symlinks, defaults to ~")

    args = parser.parse_args()

    if args.with_all:
        args.with_dotvim = True
        args.with_apps = True
        args.with_settings = True

    os.environ["DOTFILES"] = DOTFILES_PATH

    main(args)
