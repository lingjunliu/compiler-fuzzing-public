#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E "s/extern __attribute__\(\(__artificial__\)\)/extern inline __attribute__\(\(__always_inline__\)\) __attribute__\(\(__artificial__\)\)/" "$file"