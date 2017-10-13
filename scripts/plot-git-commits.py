#!/usr/bin/env python3

# To install:
# python3 -m venv ~/.pyenvs/matplotlib
# ~/.pyenvs/matplotlib/bin/pip install matplotlib

import os
import tempfile
from collections import Counter
from datetime import datetime

import matplotlib.pyplot as plt

COMMAND = "git log --date=short | grep '^Date' | cut -d ':' -f 2 | cut -d ' ' -f 4 > %s"
# --grep=fix --grep=revert --grep=bug --grep=outage -i
TEMP_FILE_PREFIX = "plot-git-commits"
TEMP_FILE_SUFFIX = ".csv"
DATE_FORMAT = "%Y-%m-%d"
CHART_FILENAME = "commits-per-day.png"


def graph(input_data, output_filename):
    """Graph the data."""
    x = list(input_data.keys())
    y = list(input_data.values())
    plt.plot(x, y)

    plt.ylabel("Commits")
    plt.title("Commits per day")
    plt.grid(False)

    print("Chart written to %s" % output_filename)
    plt.savefig(output_filename)


def main():
    temp_file = tempfile.NamedTemporaryFile(prefix=TEMP_FILE_PREFIX,
                                            suffix=TEMP_FILE_SUFFIX)
    temp_filename = temp_file.name
    print("Temp CSV for data: %s" % temp_filename)
    os.system(COMMAND % temp_filename)

    with open(temp_filename) as fp:
        counts = Counter(i.strip() for i in fp.readlines())

    data = {datetime.strptime(x[0], DATE_FORMAT): x[1] for x in counts.items()}
    graph(data, CHART_FILENAME)


if __name__ == "__main__":
    main()
