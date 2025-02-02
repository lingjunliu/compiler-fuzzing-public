#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

longVar=$(grep -oE "long\s+[a-zA-Z_][a-zA-Z0-9_]*\s*;" "$file" | \
sed -E 's/long\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*;/\1'/)

if [ -z "$longVar" ]; then
  echo "No matching patterns found."
  exit 0
fi

sed -E '/long\s+[a-zA-Z_][a-zA-Z0-9_]*\s*;/d' "$file"

random_match=$(echo "$longVar" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line=$(echo "$random_match" | cut -d: -f1)

funcName=$(grep -oE "void\s+[a-zA-Z_][a-zA-Z0-9_]*\s*\(\s*\)" "$file" | \
sed -E 's/void\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(\s*\)/\1'/)

if [ -z "$funcName" ]; then
  echo "No matching patterns found."
  exit 0
fi

sed -i -E "s/${line}/(__INTPTR_TYPE__\)${funcName}/g" "$file"