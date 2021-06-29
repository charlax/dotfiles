#!/usr/bin/env python3
import argparse
import csv
import sys
from typing import TextIO

INDENT = "  "


def split(v: str) -> list[str]:
    return v.replace("\n", " ").replace("  ", " ").replace(". ", ".\n").splitlines()


def main(infile: TextIO, outfile: TextIO) -> int:
    reader = csv.reader(infile)

    # Assumes first column is first level, headers are keys
    header = next(reader)

    for row in reader:
        # Display first col
        outfile.write(f"\n'{row[0]}':")

        for i, cell in enumerate(row):
            if i == 0:
                continue
            outfile.write(f"\n{INDENT}'{header[i]}': |")
            for line in split(cell):
                outfile.write(f"\n{INDENT * 2}{line}")

        outfile.write("\n")

    infile.close()
    outfile.close()
    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="transform a CSV into yaml")
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument(
        "outfile", nargs="?", type=argparse.FileType("w"), default=sys.stdout
    )
    parser.add_argument("--release", action="store_true")
    args = parser.parse_args()

    sys.exit(main(args.infile, args.outfile))
