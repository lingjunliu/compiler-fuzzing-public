#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Save the name of the first star parameter
mainMethod=$(grep -oE "int main\(.*\*\*[a-zA-Z_][a-zA-Z0-9_]*.*\) \{" "$file" | \
sed -E "s/int main\(.*\*\*([a-zA-Z_][a-zA-Z0-9_]*).*\) \{/\1/") 

if [ -z "$mainMethod" ]; then
  echo "No matching patterns found."
  exit 0
fi

argv=$(echo "$mainMethod" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

sed -i -E "s/_mm256_setzero_si256\(\)/_mm256_maskz_loadu_epi64\(0, ${argv}\)/" "$file"