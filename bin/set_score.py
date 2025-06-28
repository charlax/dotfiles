#!/usr/bin/env python3

import re
import sys
import math
from pathlib import Path
from typing import List, Tuple
import argparse


def extract_scores(
    lines: List[str],
) -> Tuple[float, float, List[Tuple[str, float, float]]]:
    total = 0.0
    max_score = 0.0

    # Multi-line, commented regex with named captures
    pattern = re.compile(
        r"""
        [\-\*]?\s*.{0,3}                      # bullet (- or *), optional space
        [Ss]core\s+
        (?P<category>[\w\s]+):\s*      # category label before colon
        (?P<score>\d+(?:\.\d+)?)\s*/\s*# score (may be decimal) before slash
        (?P<max>\d+(?:\.\d+)?)         # max (may be decimal) after slash
        """,
        re.IGNORECASE | re.VERBOSE,  # re.VERBOSE ignore whitespace
    )

    detailed = []
    for line in lines:
        match = pattern.match(line.strip())
        if match:
            category = match.group("category").strip()
            # Explicitly skip overall scores
            if "overall" in category.lower():
                continue
            score = float(match.group("score"))
            outof = float(match.group("max"))
            total += score
            max_score += outof
            detailed.append((category, score, outof))

    return total, max_score, detailed


def replace_overall_score(lines: List[str], score_line: str) -> List[str]:
    pattern = re.compile(r"^- Overall:\s*\d*(\.\d+)?\s*/\s*10\s*$", re.IGNORECASE)
    return [
        score_line if pattern.match(line.strip()) else line.rstrip() for line in lines
    ]


def print_score(score_10: float) -> None:
    color = "\033[92m" if score_10 >= 5 else "\033[91m"
    reset = "\033[0m"
    print(f"{color}Overall score: {score_10:.1f} / 10{reset}")


def main(path: Path, dry_run: bool) -> None:
    if not path.exists():
        print(f"Error: File '{path}' not found.", file=sys.stderr)
        sys.exit(1)

    lines = path.read_text(encoding="utf-8").splitlines()
    total, max_score, detailed_scores = extract_scores(lines)

    # Print category-level breakdown
    print("\nScore breakdown:")
    for category, score, outof in detailed_scores:
        print(f"  {category}: {score}/{outof}")

    if max_score == 0:
        print("Error: Maximum score is 0. Cannot compute ratio.", file=sys.stderr)
        sys.exit(1)

    raw_score = (total / max_score) * 10
    score_10 = math.floor(raw_score * 2) / 2  # Round down to nearest 0.5
    score_line = f"- Overall score: {score_10:.1f} / 10"

    print_score(score_10)
    new_lines = replace_overall_score(lines, score_line)

    if len(new_lines) < len(lines) - 10:
        print("Error: Too many lines removed. Aborting.", file=sys.stderr)
        sys.exit(1)

    if dry_run:
        print("\n--dry-run enabled: not writing changes.")
    else:
        path.write_text("\n".join(new_lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Compute and update 'Overall: X / 10' in file."
    )
    parser.add_argument("file", type=Path, help="Path to the input file")
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show computed score without modifying the file",
    )
    args = parser.parse_args()
    main(args.file, args.dry_run)
