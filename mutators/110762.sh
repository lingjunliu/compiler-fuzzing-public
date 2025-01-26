#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E '/v8hf\s*tmp_([a-z])\s*=\s*__builtin_shufflevector\(\1,\s*\1(,\s*-?[0-9](\.[0-9]+)?)*\);/d' "$file"
sed -i -E 's/v8hf\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*tmp_([a-z])\s*(\+|\-|\*|\/)\s*tmp_([a-z]);/return \2 \3 \4;/' "$file"
sed -i -E '/return\s*__builtin_shufflevector\(([a-zA-Z_][a-zA-Z0-9_]*),\s*\1(,\s*-?[0-9](\.[0-9]+)?)*\);/d' "$file"
