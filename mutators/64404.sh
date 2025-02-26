#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Look for typedef vint64m1_t
typedefs=$(grep -oE "typedef vint64m1_t __attribute__\(\(riscv_rvv_vector_bits\([0-9]+\)\)\) [a-zA-Z_][a-zA-Z0-9_]*;" "$file" | \
sed -E 's/typedef (vint64m1_t) __attribute__\(\(riscv_rvv_vector_bits\([0-9]+\)\)\) ([a-zA-Z_][a-zA-Z0-9_]*);/\1:\2/')

if [ -z "$typedefs" ]; then
  echo "No matching patterns found."
  exit 0
fi

# Choose a random typedef and save both data types
typedef=$(echo "$typedefs" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
type1=$(echo "$typedef" | cut -d: -f1)
type2=$(echo "$typedef" | cut -d: -f2)

# Find lines where the typedef variable is declared
typeCalls=$(grep -noE "${type2} [a-zA-Z_][a-zA-Z0-9_]*" "$file")

if [ -z "$typeCalls" ]; then
  echo "No matching patterns found."
  exit 0
fi

# Choose a random line and replace the type with the original type
typeCall=$(echo "$typeCalls" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line=$(echo "$typeCall" | cut -d: -f1)

sed -i -E "${line} s/${type2}/${type1}/" "$file"
