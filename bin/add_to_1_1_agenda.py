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

    # Find end of frontmatter
    end_of_frontmatter = 0
    if lines[0].startswith("---"):
        end_of_frontmatter = lines.index("---", 1) + 1

    # Find the existing "## Next" section or where it should be inserted
    try:
        next_index = lines.index(NEXT, end_of_frontmatter)
    except ValueError:
        next_index = -1

    # Find the end of "## Recurring" section if it exists
    end_of_recurring = None
    if "## Recurring" in lines:
        start_recurring = lines.index("## Recurring", end_of_frontmatter)
        end_of_recurring = start_recurring + 1
        while end_of_recurring < len(lines) and not lines[end_of_recurring].startswith(
            "##"
        ):
            end_of_recurring += 1

    # Determine where to insert "## Next" if it's not found
    if next_index == -1:
        insert_position = end_of_recurring if end_of_recurring else end_of_frontmatter
        lines = lines[:insert_position] + ["", NEXT] + lines[insert_position:]

    return lines


def add_next_item(lines: Lines, item: str) -> Lines:
    next_index = lines.index(NEXT)

    if lines[next_index + 1] != "":
        # Add blank line
        lines.insert(next_index, "")

    lines.insert(next_index + 2, f"{ITEM_PREFIX}{item}")
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
    # TODO: add blank line
    # lines = add_space(lines)

    assert len(lines) > start_number_of_lines, "Would result in smaller file"

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
