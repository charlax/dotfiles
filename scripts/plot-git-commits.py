#!/usr/bin/env python3

# To install:
# python3 -m venv ~/.pyenvs/matplotlib
# ~/.pyenvs/matplotlib/bin/pip install matplotlib

import os
import csv
import tempfile
from datetime import datetime

import matplotlib.pyplot as plt

COMMAND = "git log --date=short | grep '^Date' | cut -d ':' -f 2 | cut -d ' ' -f 4 | sort | uniq -c | sed -e 's/^ *//;s/ /,/' > %s"
# --grep=fix --grep=revert --grep=bug --grep=outage -i
TEMP_FILE_PREFIX = "plot-git-commits"
TEMP_FILE_SUFFIX = ".csv"
DATE_FORMAT = "%Y-%m-%d"
CHART_FILENAME = "commits-per-day.png"


def graph(x, y, output_filename):
    """Graph the data."""
    fig = plt.figure(figsize=(7, 5), dpi=300)
    plt.bar(x, y)

    moving_averages = running_mean(y, 2 * 30)
    plt.plot(x, moving_averages,
             linewidth=2,
             label="60-day moving average",
             color="tab:orange")

    plt.title("Commits per day")
    plt.grid(False)
    plt.legend()

    print("Chart written to %s" % output_filename)
    plt.savefig(output_filename)


def running_mean(l, N):
    sum_ = 0
    result = list(0 for x in l)

    for i in range(0, N):
        sum_ = sum_ + l[i]
        result[i] = sum_ / (i+1)

    for i in range(N, len(l)):
        sum_ = sum_ - l[i-N] + l[i]
        result[i] = sum_ / N

    return result


def parse_data(filename):
    """Get and parse the data."""
    x, y = [], []
    with open(filename) as f:
        reader = csv.reader(f)
        # first column is number, second is datetime
        for row in reader:
            x.append(datetime.strptime(row[1], DATE_FORMAT))
            y.append(int(row[0]))

    return x, y


def main():
    temp_file = tempfile.NamedTemporaryFile(prefix=TEMP_FILE_PREFIX,
                                            suffix=TEMP_FILE_SUFFIX)
    temp_filename = temp_file.name
    print("Temp CSV for data: %s" % temp_filename)
    os.system(COMMAND % temp_filename)

    x, y = parse_data(temp_filename)
    graph(x, y, CHART_FILENAME)


if __name__ == "__main__":
    main()
