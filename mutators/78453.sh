#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

ifWhole=$(grep -znoE "if \([^\)]*\).*return [^;]*;.*else.*return [^;]*;" "$file" | \
tr '\0' '\n' | tr -d '\n') 

if [ -z "$ifWhole" ]; then
  echo "No matching patterns found."
  exit 0
fi

random_match=$(echo "$ifWhole" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line=$(echo "$random_match" | cut -d: -f1)
statement=$(echo "$random_match" | cut -d: -f2)

newStatement=$(echo "$statement" || sed -i -E "s/if \(([^\)]*)\).*return ([^;]*);.*else.*return ([^;]*);/return \(\1 \? \2 : \3\);/")
echo "$newStatement"

sed -i -E "s/if \(([^\)]*)\)/$newStatement/" "$file"