#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E 's/if \(([a-zA-Z_][a-zA-Z0-9_]*) == ([0-9]+)\)/if \(\(\2 == \2\) \&\& \(\1 == \2\)\)/' "$file"