#!/usr/bin/env python3

import argparse
import errno
import logging
import os
import platform
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any, List, Union

import color

REPOSITORY = "https://github.com/charlax/dotfiles.git"
DOTFILES_PATH = Path(os.environ["HOME"]) / ".dotfiles"

CODE_PERSO = Path("~/CodePerso").expanduser()

ESPANSO_REPO = "git@github.com:charlax/config-espanso.git"
ESPANSO_DEST = CODE_PERSO / "espanso-config"
ESPANSO_DEFAULT_CONFIG = Path("~/Library/Application Support/espanso").expanduser()

REPOS: List[str] = [
    "git@github.com:charlax/notes.git",
    "git@github.com:charlax/website.git",
    "git@github.com:charlax/professional-programming.git",
    "git@github.com:charlax/engineering-management.git",
    "git@github.com:charlax/entrepreneurship-resources.git",
    "git@github.com:charlax/python-education.git",
]

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
    "pandoc",
    ("asdf/tool-versions", ".tool-versions"),
    ("config/cheat", ".config/cheat"),
    ("config/kitty", ".config/kitty"),
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


def confirm(msg: str) -> bool:
    print(f"{msg} Confirm (y/N)?", end=" ")
    return input().strip().lower() in ("y", "yes")


def run(
    cmd: List[os.PathLike], *args: Any, **kwargs: Any
) -> subprocess.CompletedProcess:
    kwargs.setdefault("check", True)
    print(f"$ {' '.join(str(c) for c in cmd)}")
    return subprocess.run(cmd, *args, **kwargs)


def ln(
    src: os.PathLike,
    dest: os.PathLike,
    force: bool = False,
    dry_run: bool = False,
) -> None:
    """Create a link.

    Same order as ln: dest is where the link will be created, src must exists
    """

    os.makedirs(os.path.dirname(dest), exist_ok=True)

    if os.path.exists(dest):
        try:
            actual = Path(os.readlink(dest))
        except OSError:
            actual = None

        if actual == src:
            # All good, destination matches
            return

        if not force:
            print(
                color.red(
                    f"Not symlinking {src!s}->{dest!s}: "
                    "already exists and not matching: "
                    f"dest={actual}"
                )
            )
            return

    print(f"Symlinking '{src!s}' -> '{dest!s}' {'DRY_RUN' if dry_run else ''}")
    if dry_run:
        return
    try:
        os.symlink(src, dest)
    except OSError as e:
        if e.errno == errno.EEXIST:
            try:
                os.remove(dest)
            except PermissionError:
                if confirm(f"Will try deleting entire {dest}."):
                    shutil.rmtree(dest)
                else:
                    raise
            os.symlink(src, dest)
        else:
            raise
    logging.info(f"Symlinked {src!r} -> {dest!r}")


def clone_or_update(repo: str, path: Union[str, Path]) -> None:
    """Clone or update a repo."""
    if os.path.exists(path):
        print(f"not cloning {repo}, {path} already exists")
        return

    print(color.green(f"\nCloning {repo}..."))
    run(["git", "clone", "-q", repo, path])

    try:
        print(color.green(f"\nUpdating {repo}..."))
        run(["git", "pull", "-q"], cwd=path)
        run(["git", "submodule", "-q", "init"], cwd=path)
        run(["git", "submodule", "-q", "update"], cwd=path)
    except subprocess.CalledProcessError:
        print("WARNING git pull failed, continuing anyway, repo might be outdated")


def symlink_files(args) -> None:
    """Symlink the files."""
    print(color.green("\nSymlinking configuration files..."))
    source = DOTFILES_PATH
    dest_base = Path(args.symlink_base)

    for f in CONFIGURATION_FILES:
        if isinstance(f, (tuple, list)):
            ln(
                source / f[0],
                dest_base / f[1],
                force=args.symlink_force,
                dry_run=args.dry_run,
            )
        else:
            ln(
                source / f,
                dest_base / f".{os.path.basename(f)}",
                force=args.symlink_force,
                dry_run=args.dry_run,
            )


def run_settings() -> None:
    print(color.green("\nRunning settings..."))

    os_ = platform.system()

    if os_ == "Darwin":
        run([DOTFILES_PATH / "install/set-config-osx.sh"])
    elif os_ == "Linux":
        run([DOTFILES_PATH / "install/set-config-linux.sh"])


def install_apps() -> None:
    print(color.green("\nInstall apps..."))
    run([DOTFILES_PATH / "install/install-apps-all.sh"])


def setup_espanso() -> None:
    """Setup Espanso (text expander)."""
    print(color.green("\nSetting up Espanso..."))
    clone_or_update(ESPANSO_REPO, ESPANSO_DEST)

    try:
        path = (
            run(["espanso", "path", "config"], capture_output=True)
            .stdout.decode("utf8")
            .strip()
        )
    except subprocess.CalledProcessError as exc:
        if platform.system() == "Darwin":
            print("Got error while trying to get espanso config path:")
            print(exc)
            path = ESPANSO_DEFAULT_CONFIG
            print(f"assuming it is {path}")
        else:
            raise

    print(f"Got espanso config path: {path}")

    ln(ESPANSO_DEST, path, force=True)


def clone_repos() -> None:
    for r in REPOS:
        dest = re.search(r"/([\w-]+).git$", r).group(1)
        clone_or_update(r, CODE_PERSO / dest)


def install_minimal(os_: str) -> None:
    """Install a minimal environment to streamline debugging install."""
    if os_ == "Darwin":
        packages = ["zsh", "zsh-completions", "rg", "make", "cheat", "fzf"]
        apps = ["macvim"]
        # Check brew exists and is installed
        run(["brew", "-v"])
        run(["brew", "install", *packages])
        run(["brew", "install", "--cash", *apps])


def main(args) -> int:
    """Install the dotfiles."""
    os_ = platform.system()
    if not args.skip_common:
        clone_or_update(REPOSITORY, DOTFILES_PATH)
        symlink_files(args)

        for d in ("~/.vim/temp/temp", "~/.vim/temp/backup", "~/.config/nvim"):
            os.makedirs(os.path.expanduser(d), exist_ok=True)

    if args.with_apps:
        install_minimal(os_)  # should be first
        install_apps()

    if args.with_settings:
        run_settings()

    if args.with_espanso:
        setup_espanso()

    if args.with_clones:
        clone_repos()

    print(color.green("\nInstall complete."))

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install charlax's dotfiles.")
    parser.add_argument("--with-all", action="store_true", help="Do all")
    parser.add_argument("--with-apps", action="store_true", help="Install apps")
    parser.add_argument("--with-espanso", action="store_true", help="Setup Espanso")
    parser.add_argument("--with-settings", action="store_true", help="Run settings")
    parser.add_argument("--with-clones", action="store_true", help="Clone repos")
    parser.add_argument("--skip-common", action="store_true", help="Skip common steps")

    parser.add_argument(
        "--symlink-force", "-f", action="store_true", help="Force symlink the files"
    )
    parser.add_argument("--dry-run", action="store_true", help="Dry run")
    parser.add_argument(
        "--symlink-base",
        help="Base path for symlinks, defaults to ~",
        default=os.environ["HOME"],
    )

    args = parser.parse_args()

    if args.with_all:
        args.with_apps = True
        args.with_settings = True
        args.with_espanso = True
        args.with_clones = True

    os.environ["DOTFILES"] = str(DOTFILES_PATH)

    sys.exit(main(args))
