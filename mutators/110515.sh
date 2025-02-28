#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E '/.*\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\[.*\];/{
N
s/(.*\s+)([a-zA-Z_][a-zA-Z0-9_]*)\s*\[.*\];\n\s*__builtin_memcpy\s*\(\s*\2,\s*([^,]+),\s*sizeof\s*\(.*\)\s*\)\s*;/\1*\2 = \3;/
}' "$file"
