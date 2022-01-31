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

CONFIGURATION_FILES = (
    # src, dst
    "ctags/ctags",
    "gdb/gdbinit",
    "ghci/ghci",
    "git/gitconfig",
    "git/gitignore",
    "latex/latexmkrc",
    "system/colors/dir_colors",
    "tmux/tmux.conf",
    "zsh/zshenv",
    "zsh/zshrc",
    ("asdf/tool-versions", ".tool-versions"),
    ("config/cheat", ".config/cheat"),
    ("config/fish/config.fish", ".config/fish/config.fish"),
    ("config/pudb/pudb.cfg", ".config/pudb/pudb.cfg"),
    ("config/starship.toml", ".config/starship.toml"),
    ("ctop/ctop", ".ctop"),
    ("gnupg/gpg-agent.conf", ".gnupg/gpg-agent.conf"),
    ("ssh/config", ".ssh/config"),
    ("ssh/rc", ".ssh/rc"),
    ("vim", ".vim"),
    ("vim/config/nvim/init.vim", ".config/nvim/init.vim"),
    ("vim/gvimrc", ".gvimrc"),
    ("vim/vimrc", ".vimrc"),
)


def run(cmd: List[str], *args, **kwargs) -> int:
    kwargs.setdefault("check", True)
    print(f"> {' '.join(cmd)}")
    return subprocess.run(cmd, *args, **kwargs)


def symlink(src: str, dest: str, *, should_force: bool = False) -> None:
    """Force symlink a file."""
    try:
        os.symlink(src, dest)
    except OSError as e:
        if e.errno == errno.EEXIST:
            os.remove(dest)
            os.symlink(src, dest)
            return
        raise


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
        print(f"Would have symlinked {source!r} to {dest!r}")
        return

    os.makedirs(os.path.dirname(dest), exist_ok=True)

    if os.path.exists(dest):
        if os.path.islink(dest) and os.readlink(dest) == source:
            # All good
            return

        if not force:
            print(f"Not symlinking {dest!r}: already exists")
            return

    print(f"Symlinking {source!r} -> {dest!r}")
    symlink(source, dest, should_force=force)
    logging.info(f"Symlinked {source!r} -> {dest!r}")


def clone_or_update(repo, path):
    """Clone or update a repo."""
    if not os.path.exists(path):
        print(color.green("\nCloning dotfiles repo..."))
        run(["git", "clone", "-q", repo, path])

    try:
        print(color.green("\nUpdating dotfiles repo..."))
        run(["git", "pull", "-q"], cwd=path)
        run(["git", "submodule", "-q", "init"], cwd=path)
        run(["git", "submodule", "-q", "update"], cwd=path)
    except subprocess.CalledProcessError:
        print("WARNING git pull failed, continuing anyway, repo might be outdated")


def symlink_files(args):
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
    run([os.path.join(DOTFILES_PATH, "install/set-config-all.sh")])


def install_apps():
    print(color.green("\nInstall apps..."))
    run([os.path.join(DOTFILES_PATH, "install/install-apps-all.sh")])


def main(args):
    """Install the dotfiles."""
    clone_or_update(REPOSITORY, DOTFILES_PATH)
    symlink_files(args)

    for d in ("~/.vim/temp/temp", "~/.vim/temp/backup", "~/.config/nvim"):
        os.makedirs(os.path.expanduser(d), exist_ok=True)

    if args.with_apps:
        install_apps()

    if args.with_settings:
        run_settings()

    print(color.green("\nInstall complete."))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install charlax's dotfiles.")
    parser.add_argument("--with-all", action="store_true", help="Also install apps")
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
        args.with_apps = True
        args.with_settings = True

    os.environ["DOTFILES"] = DOTFILES_PATH

    main(args)
