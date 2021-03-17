#!/usr/bin/env python3
import argparse
import csv
import re
import sys
from collections import Counter
from pathlib import Path
from typing import TextIO, List, Dict, Tuple, Any

import numpy as np
import matplotlib.pyplot as plt

FRENCH_SCALE = [
    "Je ne sais pas",
    "Pas du tout",
    "Un peu",
    "Oui",
    "Oui tout à fait",
]

Rows = List[Dict[str, str]]
XYGraph = Tuple[List[str], List[int]]

plt.style.use("ggplot")

# CSV format:
# Timestamp, Email address, Question 1, Question 2, ...


def safe_filename(v: str) -> str:
    """Return safe filename."""
    return re.sub(r"[^\w\d-]", "_", v.strip())


def get_answer_scale(rows: Rows) -> List[str]:
    """Get answer scale."""
    try:
        [int(v) for v in rows]
        return list(map(str, range(0, 11)))

    except (ValueError, TypeError):
        pass

    if all(v in FRENCH_SCALE for v in rows):
        return FRENCH_SCALE

    raise ValueError("Unknown answer scale")


def create_graph(rows: XYGraph, question: str, filename: Path, *, y_ticks: Any) -> None:
    """Create a single graph."""
    x, y = rows

    print("will plot:")
    print(x)
    print(y)

    plt.figure()
    plt.bar(x, y, color="green")
    plt.title(question, wrap=True)

    loc, labels = plt.yticks()
    plt.yticks(y_ticks)

    print(f"storing plot in {filename}")
    plt.savefig(filename)


def get_data(rows: Rows, question: str) -> XYGraph:
    """Return counter for rows."""
    values = [r[question] for r in rows]
    x = get_answer_scale(values)

    counter = Counter(values)

    return (x, [counter.get(k, 0) for k in x])


def main(csv_file: TextIO, output_dir: Path) -> int:
    output_dir.mkdir(exist_ok=True)

    dialect = csv.Sniffer().sniff(csv_file.read(1024 * 4))
    csv_file.seek(0)

    reader = csv.DictReader(csv_file, dialect=dialect)
    rows = list(reader)
    csv_file.close()

    def is_question(q: str) -> bool:
        return q not in ["Timestamp", "Email address"]

    questions = filter(is_question, rows[0].keys())

    data = {q: get_data(rows, q) for q in questions}
    max_n = max(max(v[1]) for v in data.values())
    print(max_n)
    y_ticks = np.arange(0, max_n + 2, step=2)

    for question, counter in data.items():
        filename = safe_filename(question) + ".png"
        filename = output_dir / filename
        create_graph(counter, question, filename, y_ticks=y_ticks)

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="plot nps scores")
    parser.add_argument(
        "csv_file", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument("-o", "--output_dir", required=True)
    args = parser.parse_args()

    sys.exit(main(args.csv_file, Path(args.output_dir)))
