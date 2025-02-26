#!/bin/bash


# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi


file="$1"


# Replace "_Atomic(int *) b = (int *)0;" with "_Atomic(int *) b = 0;"
sed -i -E 's/_Atomic\(int \*\) ([a-zA-Z_][a-zA-Z0-9_]*) = \(int \*\)0;/_Atomic(int *) \1 = 0;/' "$file"
