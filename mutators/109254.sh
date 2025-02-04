#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

varNames=$(grep -noE "svbool_t [a-zA-Z_][a-zA-Z0-9_]* = svptrue_b32\(\);" "$file" | \
sed -E 's/svbool_t ([a-zA-Z_][a-zA-Z0-9_]*) = svptrue_b32\(\);/\1/')

if [ -z "$varNames" ]; then
  echo "No matching patterns found."
  exit 0
fi

random_match1=$(echo "$varNames" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line1=$(echo "$random_match1" | cut -d: -f1)
varName=$(echo "$random_match1" | cut -d: -f2)

sed -i -E "${line1}d" "$file"

funcNames=$(grep -noE "svfloat32_t __attribute__\(\(noipa\)\) [a-zA-Z_][a-zA-Z0-9_]*\(.*\) \{" "$file" | \
sed -E 's/svfloat32_t __attribute__\(\(noipa\)\) ([a-zA-Z_][a-zA-Z0-9_]*)\(.*\) \{/\1/')

if [ -z "$funcNames" ]; then
  echo "No matching patterns found."
  exit 0
fi

random_match2=$(echo "$funcNames" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line2=$(echo "$random_match2" | cut -d: -f1)
funcName=$(echo "$random_match2" | cut -d: -f2)

sed -i -E "${line2}s/\) \{/, svbool_t ${varName}\) \{/" "$file"

sed -i -E "s/($funcName\(.*)\);/\1, svptrue_b32\(\)\);/" "$file"