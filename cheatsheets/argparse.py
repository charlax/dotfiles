# Setup argprase
import argparse
import sys

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="description")
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument(
        "outfile", nargs="?", type=argparse.FileType("w"), default=sys.stdout
    )
    parser.add_argument("--release", action="store_true")
    args = parser.parse_args()
