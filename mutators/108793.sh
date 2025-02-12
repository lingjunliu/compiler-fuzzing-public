#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

match=$(grep -noE '(for \(.*\))' "$file")
line=$(echo "$match" | cut -d: -f1)

sed -i -E "${line}s/\!=/>/" "$file"