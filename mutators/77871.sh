#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

nums=$(grep -oE "if \([a-zA-Z_][a-zA-Z0-9_]* \&\& [0-9]+\)" "$file" | \
sed -E "s/if \([a-zA-Z_][a-zA-Z0-9_]* \&\& ([0-9]+)\)/\1/") 

count=$(echo "$nums" | wc -l)

if [ "$count" -gt 1 ]; then
    num=$(echo "$nums" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
    sed -i -E "1 i\#define D $num" "$file"
    sed -i -E "s/([^a-zA-Z0-9_])$num([^a-zA-Z0-9_])/\1D\2/g" "$file"
fi