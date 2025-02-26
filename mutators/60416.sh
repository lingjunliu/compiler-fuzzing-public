#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

cases=$(grep -noE "case [0-9]+:" "$file")

if [ -z "$cases" ]; then
  echo "No matching patterns found."
  exit 0
fi

random_match=$(echo "$cases" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line=$(echo "$random_match" | cut -d: -f1)

sed -i -E "${line} s/case [0-9]+://" "$file"