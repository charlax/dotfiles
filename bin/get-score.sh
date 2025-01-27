#!/bin/bash

# Read from a file or standard input
input="${1:-/dev/stdin}"

grep -i 'Score' "$input" | gawk -F'/' '
{
  if (match($0, /[0-9]+[ ]*\/[ ]*[0-9]+/, arr)) {
    split(arr[0], parts, "/")
    score += parts[1]
    max += parts[2]
  }
}
END {
  if (max > 0) {
    printf "%d / %d = %.2f/10\n", score, max, score / max * 10
  } else {
    print "Error: Maximum score is 0. Cannot compute ratio."
  }
}'
