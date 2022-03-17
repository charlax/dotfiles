#!/usr/bin/env python3
import argparse
import sys
from typing import TextIO, List

import requests
from colorama import Fore, Style, init

# pip install requests colorama

init()
BASE_URL = "http://127.0.0.1:3000"


def check_url(url: str) -> None:
    res = requests.get(f"{BASE_URL}/{url}")
    if res.status_code != 200:
        print(f"{Fore.RED} {res.status_code} {url} {Style.RESET_ALL}")
    else:
        print(f"{res.status_code} {url}")


def main(infile: TextIO) -> int:
    urls: List[str] = infile.read().splitlines()
    infile.close()

    for url in urls:
        check_url(url)

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="check a list of links")
    parser.add_argument(
        "infile", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    args = parser.parse_args()

    sys.exit(main(args.infile))
