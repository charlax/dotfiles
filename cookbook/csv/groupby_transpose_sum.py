#!/usr/bin/env python3

# Files column should be:
# "day","target_status_code","count"

import argparse
import csv
import sys
from collections import defaultdict
from typing import TextIO


def main(infile: TextIO, outfile: TextIO) -> int:
    sums = defaultdict(defaultdict)
    status_codes = set([])

    reader = csv.DictReader(infile)
    for row in reader:
        status_codes.add(row["target_status_code"])
        sums[row["day"]][row["target_status_code"]] = row["count"]

    infile.close()

    sorted_days = list(sorted(sums.keys()))
    fieldnames = ["", *sorted_days]

    writer = csv.writer(outfile)
    writer.writerow(fieldnames)
    for status_code in sorted(status_codes):
        writer.writerow([status_code, *[sums[day].get(status_code) for day in sorted_days]])

    outfile.close()
    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="transpose, group by and sum")
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument(
        "outfile", nargs="?", type=argparse.FileType("w"), default=sys.stdout
    )
    args = parser.parse_args()

    sys.exit(main(args.infile, args.outfile))
