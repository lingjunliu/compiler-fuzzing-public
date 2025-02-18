#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E "s/(void [a-zA-Z_][a-zA-Z0-9_]*\(.*, ... \)) __attribute__\(.*\)([^\)]*)/\1\2/" "$file"