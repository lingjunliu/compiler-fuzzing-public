#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E "s/extern struct ([a-zA-Z_][a-zA-Z0-9_]*) \*const ([a-zA-Z_][a-zA-Z0-9_]*);/extern \1 \*const \2;/" "$file"