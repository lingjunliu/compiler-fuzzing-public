#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

unionWhole=$(grep -znoE "union [a-zA-Z_][a-zA-Z0-9_]* \{.*\};" "$file" | \
tr '\0' '\n' | tr -d '\n' | sed -E "s/(union [a-zA-Z_][a-zA-Z0-9_]* \{).*(\};)/\1\2/") 

if [ -z "$unionWhole" ]; then
  echo "No matching patterns found."
  exit 0
fi

random_match1=$(echo "$unionWhole" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

line=$(echo "$random_match1" | cut -d: -f1)
replacement=$(echo "$random_match1" | cut -d: -f2)

line2=$((line + 1))
line3=$((line2 + 1))

sed -i -E "${line} s/.*/$replacement/" "$file"
sed -i -E "${line2} s/.*//" "$file"
sed -i -E "${line3} s/\};//" "$file"