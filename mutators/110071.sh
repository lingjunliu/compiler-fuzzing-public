#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

varName=$(grep -oE 'return [a-zA-Z_][a-zA-Z0-9_]*;' "$file" | \
sed -E 's/return ([a-zA-Z_][a-zA-Z0-9_]*);/\1/')

if [ -z "$varName" ]; then
  echo "No matching patterns found."
  exit 0
fi

match=$(grep -noE "long $varName = (.*);" "$file" | \
sed -E "s/long $varName = (.*);/\1/")

if [ -z "$match" ]; then
  echo "No matching patterns found."
  exit 0
fi

line=$(echo "$match" | cut -d: -f1)
equivalent=$(echo "$match" | cut -d: -f2)

sed -i -E "${line}d" "$file"

sed -i -E "s/return ${varName};/return ${equivalent};/" "$file"

