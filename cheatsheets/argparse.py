# Setup argprase
import argparse
import sys
from typing import TextIO


def main(infile: TextIO) -> int:
    infile.close()
    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="description")
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument(
        "outfile", nargs="?", type=argparse.FileType("w"), default=sys.stdout
    )
    parser.add_argument("--release", action="store_true", help="store true")
    args = parser.parse_args()
    sys.exit(main(infile=args.infile))
