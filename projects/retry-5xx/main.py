#!/usr/bin/env python3
import argparse
import functools
import sys
import time

import requests

print = functools.partial(print, flush=True)


def main(url: str) -> int:
    start = time.perf_counter()

    while True:
        print(f"Requesting {url}... ", end="")
        # We don't use a timeout on purpose here.
        response = requests.get(url)

        print(str(response.status_code))
        if response.status_code == 200:
            break

    end = time.perf_counter()

    diff = end - start

    print(f"Took {diff} sec")

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="retry calling an endpoint until it returns an ok response"
    )
    parser.add_argument("url")
    args = parser.parse_args()

    sys.exit(main(args.url))
