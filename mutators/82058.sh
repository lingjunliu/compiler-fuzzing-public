#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Look for typedef type name
matches1=$(grep -oE 'typedef int [a-zA-Z_][a-zA-Z0-9_]* __attribute__\(\(ext_vector_type\([0-9]+\)\)\);' "$file" | \
sed -E 's/typedef int ([a-zA-Z_][a-zA-Z0-9_]*) __attribute__\(\(ext_vector_type\([0-9]+\)\)\);/\1/')
# If no matches are found, exit
if [ -z "$matches1" ]; then
#   echo "No matching patterns found."
  exit 1
fi

# randomly pick a typedef type name
typedefName=$(echo "$matches1" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')


# function header containing the type
matches2=$(grep -oE "void [a-zA-Z_][a-zA-Z0-9_]*\(.*$typedefName [a-zA-Z_][a-zA-Z0-9_]*.*\)" "$file")
# If no matches are found, exit
if [ -z "$matches2" ]; then
#   echo "No matching patterns found."
  exit 1
fi

# randomly pick a header
header=$(echo "$matches2" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')


# Get all int parameter names inside the header
matches3=$(echo "$header" | grep -oE "int [a-zA-Z_][a-zA-Z0-9_]*" | \
sed -E 's/int ([a-zA-Z_][a-zA-Z0-9_]*)/\1/')
# If no matches are found, exit
if [ -z "$matches2" ]; then
#   echo "No matching patterns found."
  exit 1
fi

# Randomly pick a parameter
intName=$(echo "$matches3" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

# Save the typedef variable name
varName=$(echo "$header" | grep -oE "$typedefName [a-zA-Z_][a-zA-Z0-9_]*" | \
sed -E "s/$typedefName ([a-zA-Z_][a-zA-Z0-9_]*)/\1/")

# Replace int variable with the typedef variable
sed -i -E "s/__builtin_popcountg\($intName\);/__builtin_popcountg\($varName\);/" "$file"
