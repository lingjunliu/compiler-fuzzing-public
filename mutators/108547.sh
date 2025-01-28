#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E '/long\s+[a-zA-Z_][a-zA-Z0-9_]*/d' "$file"

var1=$(grep -oE "void\s+[a-zA-Z_][a-zA-Z0-9_]*\s*\(\s*\)" "$file" | \
sed -E 's/void\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(\s*\)/\1'/)

if [ -z "$var1" ]; then
  echo "No matching patterns found."
  exit 0
fi

var2=$(grep -oE "for\s*\(\s*;\s*[a-zA-Z_][a-zA-Z0-9_]*\s*;\s*\)" "$file" | \
sed -E 's/for\s*\(\s*;\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*;\s*\)/\1/')

if [ -z "$var2" ]; then
  echo "No matching patterns found."
  exit 0
fi

sed -i -E "s/${var2}\s*\+=\s*[a-zA-Z_][a-zA-Z0-9_]*\s*/${var2} \+= \(__INTPTR_TYPE__\)${var1}/" "$file"