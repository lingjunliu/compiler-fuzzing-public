#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Read in the entire union
unionWhole=$(grep -znoE "union \{(.*)\} [a-zA-Z_][a-zA-Z0-9_]* = \{.*\};" "$file" | \
tr '\0' '\n')

if [ -z "$unionWhole" ]; then
  echo "No matching patterns found."
  exit 0
fi
echo "$unionWhole"

# Save the line number and the remaining
unionLine=$(echo "$unionWhole" | cut -d: -f1)
union=$(echo "$unionWhole" | cut -d: -f2)

# Find in the union where an array is declared
arrays=$(echo "$union" | grep -oE "[a-zA-Z_][a-zA-Z0-9_]* [a-zA-Z_][a-zA-Z0-9_]*\[[0-9]+\];" "$file")
if [ -z "$arrays" ]; then
  echo "No matching patterns found."
  exit 0
fi
# Randomly select one declaration
originalArray=$(echo "$arrays" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
echo "$originalArray"

# In the randomly selected declaration, remove the size
alteredArray=$(echo "$originalArray" | sed -E "s/([a-zA-Z_][a-zA-Z0-9_]* [a-zA-Z_][a-zA-Z0-9_]*)\[[0-9]+\];/\1\[\];/")
echo "$alteredArray"

# Replace the old declaration with the new one
alteredUnion=$(echo "$union" | sed -E "s/${originalArray}/${alteredArray}/")
echo "$alteredUnion"

# Apply the change to the file
sed -i -E "${unionLine}s/.*/${alteredUnion}/" "$file"

