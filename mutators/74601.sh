#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Read in entire struct
structs=$(grep -zoE "typedef struct \{[^}]*\} [a-zA-Z_][a-zA-Z0-9_]*;" "$file" | \
tr '\0' '\n' | tr -d '\n') 

if [ -z "$structs" ]; then
  echo "No matching patterns found."
  exit 0
fi

struct=$(echo "$structs" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

# Save struct name
structName=$(echo "$struct" | sed -E "s/typedef struct \{[^}]*\} ([a-zA-Z_][a-zA-Z0-9_]*);/\1/")


# Select a random variable inside struct, save the type
vars=$(echo"$struct" | grep -oE "([a-zA-Z_][a-zA-Z0-9_]*) [a-zA-Z_][a-zA-Z0-9_]*;" | \
sed -E "s/([a-zA-Z_][a-zA-Z0-9_]*) [a-zA-Z_][a-zA-Z0-9_]*;/\1/")

if [ -z "$vars" ]; then
  echo "No matching patterns found."
  exit 0
fi

type=$(echo "$vars" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

echo "$type"

# Find a method containing that type as a parameter and save the method name
methods=$(grep -oE "[a-zA-Z_][a-zA-Z0-9_]*\($type [a-zA-Z_][a-zA-Z0-9_]*\)" "$file" | \
sed -i -E "s/([a-zA-Z_][a-zA-Z0-9_]*)\($type [a-zA-Z_][a-zA-Z0-9_]*\)/\1/") 

if [ -z "$methods" ]; then
  echo "No matching patterns found."
  exit 0
fi

methodName=$(echo "$methods" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

echo "$methodName"





