#!/usr/bin/env python3

# To install:
# python3 -m venv ~/.pyenvs/matplotlib
# ~/.pyenvs/matplotlib/bin/pip install matplotlib

import argparse
import csv
from datetime import datetime

import matplotlib.pyplot as plt

DATE_FORMAT = "%Y-%m-%d"
DEFAULT_OUTPUT_FILENAME = "graph.png"
DEFAULT_TITLE = "Title"


def graph(*, title, data, output_filename):
    """Graph the data."""
    x, y = data
    plt.bar(x, y)

    plt.title(title)
    plt.grid(False)

    print("Chart written to %s" % output_filename)
    plt.savefig(output_filename)


def parse_data(filename):
    """Get and parse the data."""
    x, y = [], []
    with open(filename) as f:
        reader = csv.reader(f)
        for row in reader:
            x.append(datetime.strptime(row[1], DATE_FORMAT))
            y.append(row[0])

    return x, y


def main(*, title, input_filename, output_filename):
    data = parse_data(input_filename)
    graph(title=title, data=data, output_filename=output_filename)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot data with matplotlib")
    parser.add_argument("--title", default=DEFAULT_TITLE,
                        help="Title")
    parser.add_argument("input_filename",
                        help="input filename")
    parser.add_argument("--output-filename",
                        default=DEFAULT_OUTPUT_FILENAME,
                        help="output filename")
    args = parser.parse_args()
    main(title=args.title,
         input_filename=args.input_filename,
         output_filename=args.output_filename,
         )
