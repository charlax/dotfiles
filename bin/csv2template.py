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

    template_string = args.template_string
    if not template_string:
        template_string = args.template.read()
    template = jinja2.Template(template_string)

    for line in csv_file:
        line = {k.replace(' ', '_'): v for k, v in line.iteritems()}
        args.outfile.write(template.render(**line) + "\n")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Render the template using CSV data")
    parser.add_argument("csv", type=argparse.FileType('rU'))

    template_group = parser.add_mutually_exclusive_group(required=True)
    template_group.add_argument(
        "template", type=argparse.FileType('r'), nargs='?')
    template_group.add_argument("--template", dest='template_string')

    parser.add_argument('outfile', nargs='?', type=argparse.FileType('w'),
                        default=sys.stdout)

    args = parser.parse_args()

    main(args)
