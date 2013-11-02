#!env python
"""
csv2template.py

Objective: takes a CSV and a Jinja2 template as input, output the
rendered template.
"""
import argparse
import csv
import sys

import jinja2


def main(args):

    csv_file = csv.DictReader(args.csv)
    template = jinja2.Template(args.template.read())

    for line in csv_file:
        args.outfile.write(template.render(**line))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Render the template using CSV data")
    parser.add_argument("csv", type=argparse.FileType('rU'))
    parser.add_argument("template", type=argparse.FileType('r'))
    parser.add_argument('outfile', nargs='?', type=argparse.FileType('w'),
                        default=sys.stdout)

    args = parser.parse_args()
    main(args)
