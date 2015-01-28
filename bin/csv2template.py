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


def get_template(args):
    """Return template."""
    template_string = args.template_string
    if not template_string:
        if args.use_csv_header_as_template:
            template_string = args.csv.readline()
        else:
            template_string = args.template.read()

    template = jinja2.Template(template_string)
    return template


def main(args):
    """Render the template."""
    template = get_template(args)

    if args.header:
        args.outfile.write(args.header + "\n")

    csv_file = csv.DictReader(args.csv)
    rows = ({k.strip(): v.strip() for k, v in row.iteritems()} for row in csv_file)
    for line in rows:
        line = {k.replace(' ', '_'): v for k, v in line.iteritems()}
        args.outfile.write(template.render(**line) + "\n")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Render the template using CSV data")
    parser.add_argument("csv", type=argparse.FileType('rU'))
    parser.add_argument("--header",
                        help='content to put at the top of output')

    template_group = parser.add_mutually_exclusive_group(required=True)
    template_group.add_argument(
        "--template",
        type=argparse.FileType('r'),
        help='template filename')
    template_group.add_argument(
        "--template-string",
        help='template string')
    template_group.add_argument(
        "--template-use-csv-header",
        action='store_true',
        dest='use_csv_header_as_template',
        help="Use the CSV's first line as the template")

    parser.add_argument('--outfile',
                        type=argparse.FileType('w'),
                        default=sys.stdout)

    args = parser.parse_args()

    main(args)
