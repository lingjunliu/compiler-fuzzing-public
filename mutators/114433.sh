#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Find a variable compared in a return statement 
matches1=$(grep -oE 'return [a-zA-Z_][a-zA-Z0-9_]* << [0-9]+;' "$file" | \
sed -E "s/return ([a-zA-Z_][a-zA-Z0-9_]*) << [0-9]+;/\1/")

if [ -z "$matches1" ]; then
  echo "No matching patterns found."
  exit 0
fi

var=$(echo "$matches1" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')


# Find where the variable is declared and save the value it is equivalent to
matches2=$(grep -noE "$var = .*;" "$file" | \
sed -E "s/$var = (.*);/\1/")

if [ -z "$matches2" ]; then
  echo "No matching patterns found."
  exit 0
fi

random_match=$(echo "$matches2" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
line=$(echo "$random_match" | cut -d: -f1)
val=$(echo "$random_match" | cut -d: -f2)

# Delete the variable declaration
sed -i -E "$line d" "$file"
# When the variable is used, replace it with the value it is equivalent to
sed -i -E "s/$var/$val/" "$file"