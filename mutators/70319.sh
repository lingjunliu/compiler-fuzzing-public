#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Look for struct declarations
matches=$(grep -oE "struct [a-zA-Z_][a-zA-Z0-9_]*" "$file" | \
sed -E 's/struct ([a-zA-Z_][a-zA-Z0-9_]*)/\1'/)

if [ -z "$matches" ]; then
  echo "No matching patterns found."
  exit 0
fi

# randomly select a struct name
structName=$(echo "$matches" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

# Replace const structName &var with structName var
sed -i -E "s/const ${structName} \&([a-zA-Z_][a-zA-Z0-9_]*)/${structName} \1/" "$file"
