#!/bin/bash

# Read from a file or standard input
input="${1:-/dev/stdin}"

# Support decimal scores too

grep -i '\/' "$input" | gawk -F'/' '
{
  # Skip lines that contain "Overall: x / y"
  if ($0 ~ /Overall:[ ]*[0-9]+(\.[0-9]+)?[ ]*\/[ ]*[0-9]+(\.[0-9]+)?/) {
    next  # Skip this line
  }

  if (match($0, /[0-9]+(\.[0-9]+)?[ ]*\/[ ]*[0-9]+(\.[0-9]+)?/, arr)) {
    print($0)
    split(arr[0], parts, "/")
    score += parts[1] + 0  # Convert to number to handle decimals
    max += parts[2] + 0    # Convert to number to handle decimals
  }
}
END {
  if (max > 0) {
    printf "\n%.1f / %.1f = %.2f/10\n", score, max, score / max * 10
  } else {
    print "\nError: Maximum score is 0. Cannot compute ratio."
  }
}'
