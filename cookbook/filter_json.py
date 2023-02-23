#!/usr/bin/env python
"""Filter JSON

This script can be useful when jq is not enough (e.g., as of writing
it does not support millisecond precision when parsing datetime).
"""

import argparse
import json
import sys
from typing import Dict, Any
from datetime import datetime, timedelta


def should_keep(item: Dict[str, Any]) -> bool:
    return item["foo"] == "stuff" and datetime.fromisoformat(item["createdAt"]) < (
        datetime.now() - timedelta(hours=9)
    )


def main(content) -> Dict[str, Any]:
    items = filter(should_keep, content["items"])
    return {"items": items}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="filter json items")
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument(
        "outfile", nargs="?", type=argparse.FileType("w"), default=sys.stdout
    )
    args = parser.parse_args()

    content = json.load(args.infile)
    json.dump(content, args.outfile)

    sys.exit(0)
