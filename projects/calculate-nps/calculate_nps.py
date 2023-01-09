#!/usr/bin/env python3
import argparse
import sys
from collections import Counter
from typing import Iterator, TextIO


def main(infile: TextIO) -> int:
    scores: Iterator[int] = map(int, infile.read().split())
    infile.close()

    counter = Counter(scores)
    n = sum(v for v in counter.values())

    detractors = sum(v for k, v in counter.items() if k < 7)
    promoters = sum(v for k, v in counter.items() if k > 8)

    p_detractors = (detractors / n) * 100
    p_promoters = (promoters / n) * 100

    nps = p_promoters - p_detractors

    for k in range(11):
        print(f"{k}: {counter.get(k, 0)}")

    print("\n")

    print(f"n= {n}")
    print(f"n_detractors= {detractors} ({p_detractors}%)")
    print(f"n_promoters= {promoters} ({p_promoters}%)")
    print(f"NPS= {nps}")

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="calculate the net promoter score")
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    args = parser.parse_args()

    sys.exit(main(args.infile))
