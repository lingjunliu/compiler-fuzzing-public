#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

match=$(grep -oE 'int [a-zA-Z_][a-zA-Z0-9_]* = \(int\)[a-zA-Z_][a-zA-Z0-9_]*;' "$file" | \
sed -E 's/int ([a-zA-Z_][a-zA-Z0-9_]*) = \(int\)([a-zA-Z_][a-zA-Z0-9_]*);/\1,\2/')

sed -i -E '/int [a-zA-Z_][a-zA-Z0-9_]* = \(int\)[a-zA-Z_][a-zA-Z0-9_]*;/d' "$file"

if [ -z "$match" ]; then
  echo "No matching patterns found."
  exit 1
fi

temp=$(echo "$match" | cut -d',' -f1)
var=$(echo "$match" | cut -d',' -f2)

sed -i -E "s/([a-zA-Z_][a-zA-Z0-9_]*) \+= $temp;/\1 += $var;/g" "$file"