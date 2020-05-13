#!/usr/bin/env python3
import argparse
import csv
import re
import sys
from collections import Counter
from pathlib import Path
from typing import TextIO, List, Dict

import matplotlib.pyplot as plt

plt.style.use("ggplot")

# CSV format:
# Timestamp, Email address, Question 1, Question 2, ...


def safe_filename(v: str) -> str:
    """Return safe filename."""
    return re.sub(r"[^\w\d-]", "_", v.strip())


def create_graph(rows: List[Dict[str, str]], question: str, filename: Path):
    """Create a single graph."""
    x = list(map(str, range(0, 11)))
    counts = Counter([r[question] for r in rows])
    y = [counts.get(i, 0) for i in x]

    print("will plot:")
    print(x)
    print(y)

    plt.figure()
    plt.bar(x, y, color="green")
    plt.title(question, wrap=True)

    print(f"storing plot in {filename}")
    plt.savefig(filename)


def main(csv_file: TextIO, output_dir: Path) -> int:
    output_dir.mkdir(exist_ok=True)

    reader = csv.DictReader(csv_file)
    rows = list(reader)
    csv_file.close()

    def is_question(q: str) -> bool:
        return q not in ["Timestamp", "Email address"]

    questions = filter(is_question, rows[0].keys())

    for q in questions:
        filename = safe_filename(q) + ".png"
        filename = output_dir / filename
        create_graph(rows, q, filename)

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="plot nps scores")
    parser.add_argument(
        "csv_file", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument("output_dir")
    args = parser.parse_args()

    sys.exit(main(args.csv_file, Path(args.output_dir)))
