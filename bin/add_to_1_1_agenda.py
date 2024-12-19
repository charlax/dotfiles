#!/usr/bin/env python3

# See tests

import argparse
import logging
import os
import os.path
import sys
from contextlib import contextmanager
from pathlib import Path
from typing import List, TextIO

Lines = List[str]
NEXT = "## Next"
ITEM_PREFIX = "- "


class FileAlreadyExistsException(Exception):
    pass


def maybe_add_next(lines: Lines) -> Lines:
    if NEXT in lines:
        return lines

    if not lines:
        return [NEXT, ""]

    # Find end of frontmatter
    current_index = 0
    if lines[0].startswith("---"):
        current_index = lines.index("---", 1) + 1

    for current_index in range(current_index, len(lines)):
        if lines[current_index].strip() == "":
            continue

        # h1 title
        if lines[current_index].startswith("# "):
            continue

        if (
            lines[current_index].startswith("##")
            and "recurring" in lines[current_index].lower()
        ):
            continue

        if lines[current_index].startswith("## "):
            # Backtrack one since we should add before this title.
            current_index -= 1
            break

    # print(f"current_index = {current_index}")
    # print(f"current line = {lines[current_index]}")
    # print(f"start = {lines[:current_index+1]}")
    # print(f"end = {lines[current_index+1:]}")

    # Wether or not to add an empty line
    to_add = [NEXT, ""] if lines[current_index].strip() == "" else ["", NEXT, ""]
    lines = lines[: current_index + 1] + to_add + lines[current_index + 1 :]

    return lines


def add_next_item(lines: Lines, item: str) -> Lines:
    item_to_add = f"{ITEM_PREFIX}{item}"
    next_index = lines.index(NEXT)

    if len(lines) > next_index + 2 and lines[next_index + 2] == item_to_add:
        # The item is already there, skipping
        return lines

    lines.insert(next_index + 2, item_to_add)

    # We're at the end, no need to add blank line
    if len(lines) == next_index + 2:
        return lines

    # Add blank line before next header
    i = next_index + 2
    while i < len(lines) and lines[i] != "":
        if lines[i].startswith("#"):
            lines.insert(i, "")
            break

        i += 1

    return lines


def clean_line(line: str) -> str:
    return line.rstrip()


@contextmanager
def atomic_write(filename: Path):
    tmp = Path(str(filename) + ".tmp")
    logging.debug(f"atomic_write filename={filename} tmp={tmp!s}")

    if os.path.isfile(tmp):
        raise FileAlreadyExistsException(f"Temporary file {tmp} already exits")

    with open(tmp, "w") as f:
        yield f
        f.flush()
        os.fsync(f.fileno())

    os.replace(tmp, filename)


def add_item(f: TextIO, item: str, is_dry_run: bool = False) -> None:
    """Add an item to a 1-1 agenda."""
    lines = [clean_line(line) for line in f.read().splitlines()]
    start_number_of_lines = len(lines)

    lines = maybe_add_next(lines)
    lines = add_next_item(lines, item)

    assert len(lines) >= start_number_of_lines, "Would result in smaller file"

    if is_dry_run:
        print(f"Would write in {f.name}:")
        print(lines[:10])
        return

    print(f"Will write {f.name}")
    with atomic_write(Path(f.name)) as f:
        f.write("\n".join(lines))


def main(
    infiles: List[TextIO],
    item: str = "",
    is_dry_run: bool = False,
    is_verbose: bool = False,
) -> int:
    if is_verbose:
        logging.basicConfig(level=logging.DEBUG)

    for f in infiles:
        add_item(f, item, is_dry_run)

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="add an item to 1-1 agenda")
    parser.add_argument(
        "infiles",
        nargs="+",
        type=argparse.FileType("r+"),
    )
    parser.add_argument("-i", "--item", required=True)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("-v", "--verbose", action="store_true")
    args = parser.parse_args()

    sys.exit(
        main(
            args.infiles,
            item=args.item,
            is_dry_run=args.dry_run,
            is_verbose=args.verbose,
        )
    )
