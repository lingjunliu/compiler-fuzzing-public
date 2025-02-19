#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E "s/__builtin_rotateleft([0-9]+)\(([a-zA-Z_][a-zA-Z0-9_]*), ([0-9]+)\) \& (0x[A-F0-9]*L?);/\
__builtin_rotateleft\1\(\(\2 \& \4\), \3\);/" "$file"