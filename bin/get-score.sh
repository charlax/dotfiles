#!/bin/bash

# Read from a file or standard input
input="${1:-/dev/stdin}"

# Support decimal scores too

grep -i '\/' "$input" | gawk -F'/' '
{
  if (match($0, /[0-9]+(\.[0-9]+)?[ ]*\/[ ]*[0-9]+(\.[0-9]+)?/, arr)) {
    split(arr[0], parts, "/")
    score += parts[1] + 0  # Convert to number to handle decimals
    max += parts[2] + 0    # Convert to number to handle decimals
  }
}
END {
  if (max > 0) {
    printf "%.1f / %.1f = %.2f/10\n", score, max, score / max * 10
  } else {
    print "Error: Maximum score is 0. Cannot compute ratio."
  }
}'
