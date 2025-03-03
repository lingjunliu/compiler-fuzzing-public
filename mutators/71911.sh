#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

sed -i -E s/"__builtin_classify_type\(typeof\(([a-zA-Z_][a-zA-Z0-9_]*)\)\)/__builtin_classify_type\(\1\)/" "$file"