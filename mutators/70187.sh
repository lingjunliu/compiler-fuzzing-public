#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Choose a random 2d array declaration, save the name and the first size
arrays=$(grep -noE "[a-zA-Z_][a-zA-Z0-9_]* [a-zA-Z_][a-zA-Z0-9_]*\[[0-9]+\]\[[0-9]+\]" "$file" | \
sed -E "s/[a-zA-Z_][a-zA-Z0-9_]* ([a-zA-Z_][a-zA-Z0-9_]*)\[([0-9]+)\]\[[0-9]+\]/\1:\2/") 

if [ -z "$arrays" ]; then
  echo "No matching patterns found."
  exit 0
fi

echo "$arrays"

array=$(echo "$arrays" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
declareLine=$(echo "$array" | cut -d: -f1)
arrayName=$(echo "$array" | cut -d: -f2)
defaultSize=$(echo "$array" | cut -d: -f3)


# Look for when the selected array is used, save line number and index used
arrayCalls=$(grep -noE "$arrayName\[([0-9]+)\]\[[0-9]+\]" "$file" | \
sed -E "s/$arrayName\[([0-9]+)\]\[[0-9]+\]/\1/") 

if [ -z "$arrayCalls" ]; then
  echo "No matching patterns found."
  exit 0
fi

echo "$arrayCalls"

arrayCall=$(echo "$arrayCalls" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line=$(echo "$arrayCall" | cut -d: -f1)
indexUsed=$(echo "$arrayCall" | cut -d: -f2)

# new size = array default size + index used
newSize=$((defaultSize + indexUsed))

# Replace the index with the new size
sed -i -E "$line s/$arrayName\[[0-9]+\]\[([0-9]+)\]/$arrayName\[$newSize\]\[\1\]/" "$file"
