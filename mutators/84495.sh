#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Name of the first parameter
matches=$(grep -noE '[a-zA-Z_][a-zA-Z0-9_]* [a-zA-Z_][a-zA-Z0-9_]*\([a-zA-Z_][a-zA-Z0-9_]* \*([a-zA-Z_][a-zA-Z0-9_]*)(, .*)*\) \{' "$file" | \
sed -E 's/[a-zA-Z_][a-zA-Z0-9_]* [a-zA-Z_][a-zA-Z0-9_]*\([a-zA-Z_][a-zA-Z0-9_]* \*([a-zA-Z_][a-zA-Z0-9_]*)(, .*)*\) \{/\1/')

if [ -z "$matches" ]; then
  echo "No matching patterns found."
  exit 0
fi

rand_match=$(echo "$matches" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line=$(echo "$rand_match" | cut -d: -f1)
paramName=$(echo "$rand_match" | cut -d: -f2)

# Remove the first parameter from the function header
sed -i -E "${line} s/([a-zA-Z_][a-zA-Z0-9_]* [a-zA-Z_][a-zA-Z0-9_]*\()[a-zA-Z_][a-zA-Z0-9_]* \*[a-zA-Z_][a-zA-Z0-9_]*, /\1/" "$file"

# Remove the parameter from va_start
sed -i -E "s/(va_start\([a-zA-Z_][a-zA-Z0-9_]*), $paramName\);/\1\);/" "$file"