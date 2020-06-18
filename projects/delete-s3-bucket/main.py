#!/usr/bin/env python3
import argparse
import sys

import boto3


def main(bucket: str) -> int:
    print(f"Deleting bucket {bucket} (y/N)?")
    answer = input()

    if answer != "y":
        print("Not deleting")
        return -1

    s3 = boto3.resource('s3')
    bucket = s3.Bucket(bucket)
    bucket.object_versions.delete()
    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="delete an S3 bucket completely")
    parser.add_argument("bucket", nargs=1)
    args = parser.parse_args()

    sys.exit(main(args.bucket[0]))
