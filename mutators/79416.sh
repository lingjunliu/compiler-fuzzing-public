#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E 's/^([[:space:]]*)#pragma[[:space:]]+omp[[:space:]]+teams[[:space:]]+parallel[[:space:]]+num_teams\(([a-zA-Z_][a-zA-Z0-9_]*)\)[[:space:]]+num_threads\(([a-zA-Z_][a-zA-Z0-9_]*)\)/\1#pragma omp teams num_teams(\2)\n\1#pragma omp parallel num_threads(\3)/' "$file"
