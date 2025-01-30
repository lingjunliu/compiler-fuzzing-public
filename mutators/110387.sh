#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E 's/arr\[0\]/a/g; s/arr\[1\]/b/g; s/arr\[2\]/c/g; s/arr\[3\]/d/g; s/arr\[4\]/a, b, c, d/g' "$file"
