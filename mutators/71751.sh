#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

sed -i -E 's/uint8_t ([a-zA-Z_][a-zA-Z0-9_]*) = \(uint8_t\)vqrshrunh_n_s16(\([a-zA-Z_][a-zA-Z0-9_]*, [0-9]+\));/uint8_t \1 = vqrshrunh_n_s16\2;/' "$file"