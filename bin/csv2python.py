#!env python
"""
csv2python.py

Takes a CSV and Python script as input, call a ``handle()`` function in the
script repeatedly which each line of the CSV file.
"""
import argparse
import csv
import imp


def get_handle_function(script_filename):
    """Get the handle function from a filename."""
    script = imp.load_source('handler', script_filename)
    return script.handle


def main(args):
    """Render the template."""
    csv_file = csv.DictReader(args.csv)
    handle = get_handle_function(args.python_script)
    rows = [{k.strip(): v.strip()
             for k, v in row.iteritems()} for row in csv_file]

    total = len(rows)
    print('%d rows to handle.' % total)
    for i, line in enumerate(rows):
        if i == args.stop_after:
            print('Stopping after %d iteration.' % args.stop_after)
            break
        print('Handling row %d/%d' % (i + 1, total))
        handle(line)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Render the template using CSV data")
    parser.add_argument("csv", type=argparse.FileType('rU'))
    parser.add_argument("python_script", type=str)
    parser.add_argument(
        "--stop-after",
        type=int,
        help='stop after x iteration')
    args = parser.parse_args()

    main(args)
