#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

match=$(grep -oE '\([a-zA-Z_][a-zA-Z0-9\._]* \& 0x[a-z0-9_]+\) \|\| \([a-zA-Z_][a-zA-Z0-9\._]* \& 0x[a-z0-9_]+\)' "$file" | \
sed -E 's/\([a-zA-Z_][a-zA-Z0-9\._]* \& (0x[a-z0-9_]+)\) \|\| \([a-zA-Z_][a-zA-Z0-9\._]* \& (0x[a-z0-9_]+)\)/\1,\2/')

if [ -z "$match" ]; then
  echo "No matching patterns found."
  exit 0
fi

num1=$(echo "$match" | cut -d, -f1)
num2=$(echo "$match" | cut -d, -f2)
sum=$((num1 + num2))
sum_hex=$(printf "0x%X" "$sum" | tr 'A-F' 'a-f')

sed -i -E "s/\(([a-zA-Z_][a-zA-Z0-9\._]*) \& 0x[a-z0-9_]+\) \|\| \([a-zA-Z_][a-zA-Z0-9\._]* \& 0x[a-z0-9_]+\)/\1 \& ${sum_hex}/" "$file"
