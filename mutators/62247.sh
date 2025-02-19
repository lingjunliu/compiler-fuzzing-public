#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

printfs=$(grep -noE "printf\(\".*%llb.*\"(, [a-zA-Z_][a-zA-Z0-9_]*)*\);" "$file")

if [ -z "$printfs" ]; then
  echo "No matching patterns found."
  exit 0
fi

printf=$(echo "$printfs" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line=$(echo "$printf" | cut -d: -f1)

sed -i -E "${line}s/%llb/%lb/" "$file"
