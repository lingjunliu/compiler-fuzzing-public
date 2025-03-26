#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Check that a volatile struct exists
structWhole=$(grep -zoE "struct \{.*\} volatile .*;" "$file" | \
tr '\0' '\n' | tr -d '\n') 

if [ -z "$structWhole" ]; then
  echo "No matching patterns found."
  exit 0
fi

# Remove volatile from that struct
sed -i -E "s/\} volatile (.*);/\} \1;/" "$file"