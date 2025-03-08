#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

# Use sed to add 'allocate(x_alloc : x)' to any OpenMP directive with 'private(x)'
# - '^#pragma omp.*private(x)' matches lines starting with '#pragma omp' and containing 'private(x)'
# - 's/$/ allocate(x_alloc : x)/' appends 'allocate(x_alloc : x)' to the end of those lines
sed -i -E '/^#pragma omp.*private(x)/ s/$/ allocate(x_alloc : x)/' "$file"
