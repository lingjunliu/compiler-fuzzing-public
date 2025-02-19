#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Find all bool declarations and save their variable names
bools=$(grep -oE "^\s*static bool [a-zA-Z_][a-zA-Z0-9_]* = (true|false);" "$file" | \
sed -E 's/^\s*static bool ([a-zA-Z_][a-zA-Z0-9_]*) = (true|false);/\1/')
if [ -z "$bools" ]; then
  echo "No matching patterns found."
  exit 0
fi

# Select a random bool name
boolName=$(echo "$bools" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

# Find all bool declarations inside curly braces
blockBools=$(grep -noE "static bool [a-zA-Z_][a-zA-Z0-9_]* = (true|false);" "$file")
if [ -z "$blockBools" ]; then
  echo "No matching patterns found."
  exit 0
fi

# Pick a random one and save its line number
blockBool=$(echo "$blockBools" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line=$(echo "$blockBool" | cut -d: -f1)

# In the selected line, replace the variable name with the selected bool name
sed -i -E "${line} s/static bool [a-zA-Z_][a-zA-Z0-9_]* = (true|false);/\
static bool ${boolName} = \1;/" "$file"