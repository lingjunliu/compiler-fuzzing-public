#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E  "s/int ([a-zA-Z_][a-zA-Z0-9_]*) =(.*) 0 (.*);/int \1 =\2 \1 \3;/" "$file"