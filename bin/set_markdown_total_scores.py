#!/usr/bin/env python3
import re
import sys
from pathlib import Path


def calculate_section_score(section_text: str) -> int:
    """Calculate total points from checkbox items in a section.

    Matches patterns like:
    - [ ] (8 pt) description
    - [ ] (4 pt) description

    Does not match negative:
    - (-1 pt) penalty description
    """
    # Match both positive and negative points
    pattern = r"\[.\]\s*\((\d+)\s*pt\)"
    matches = re.findall(pattern, section_text)
    return sum(int(pts) for pts in matches)


def update_score_headers(content: str) -> tuple[str, int]:
    """Update all '➡️ Score' headers with calculated totals.

    The checkboxes with points appear BEFORE each ➡️ Score line, within the
    section that starts with a ### header. So we need to look backwards from
    each score line to find the relevant content.

    Returns the updated content and the grand total of all section scores.
    """
    # Split content into sections at scoring headers
    # Pattern matches: ➡️ Score followed by optional existing total
    sections = re.split(r"(➡️ Score[^\n]*:\s*/(?:\s*\d+)?)", content)

    result: list[str] = []
    grand_total = 0
    i = 0

    while i < len(sections):
        if i + 1 < len(sections) and sections[i + 1].startswith("➡️ Score"):
            # Found a score header - content BEFORE it contains the checkboxes
            preceding_content = sections[i]

            # Find the last ### header in the preceding content to get section start
            section_start_match = None
            for match in re.finditer(r"###[^\n]*\n", preceding_content):
                section_start_match = match

            if section_start_match:
                scoring_content = preceding_content[section_start_match.start() :]
            else:
                scoring_content = preceding_content

            # Calculate total
            total = calculate_section_score(scoring_content)
            grand_total += total

            # Update header - handles both existing and missing totals
            updated_header = re.sub(
                r"(➡️ Score[^:]*:\s*/)(?:\s*\d+)?", rf"\1 {total}", sections[i + 1]
            )

            result.append(sections[i])
            result.append(updated_header)
            i += 2
        else:
            result.append(sections[i])
            i += 1

    return "".join(result), grand_total


def update_overall_score(content: str, grand_total: int) -> str:
    """Update the overall score line with the grand total."""
    # Match "- Overall: / X ..." and replace the entire line after "/"
    pattern = r"(- Overall(?:\s+score)?:\s*/)[^\n]*"
    replacement = rf"\1 {grand_total} hence TODO %"
    return re.sub(pattern, replacement, content)


def main() -> None:
    if len(sys.argv) != 2:
        print("Usage: python update_scores.py <markdown_file>")
        sys.exit(1)

    filepath = Path(sys.argv[1])

    if not filepath.exists():
        print(f"Error: File '{filepath}' not found")
        sys.exit(1)

    content = filepath.read_text(encoding="utf-8")
    updated_content, grand_total = update_score_headers(content)
    updated_content = update_overall_score(updated_content, grand_total)
    filepath.write_text(updated_content, encoding="utf-8")

    print(f"Updated scores in {filepath}")


if __name__ == "__main__":
    main()
