#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

sed -i -E "s/(extern void [a-zA-Z_][a-zA-Z0-9_]*\(.*)void \*([a-zA-Z_][a-zA-Z0-9_]*)([^a-zA-Z0-9_].*\);)/\1std::ostream \&\2\3/" "$file"
