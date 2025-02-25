#!/bin/bash


# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi


file="$1"


# Replace "return func2(i);" with "[[clang::musttail]] return func2(i);"
sed -i -E 's/return ([a-zA-Z_][a-zA-Z0-9_]*\([a-zA-Z_][a-zA-Z0-9_]*\));/[[clang::musttail]] return \1;/' "$file"
