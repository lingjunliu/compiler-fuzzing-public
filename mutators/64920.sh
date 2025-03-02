#!/bin/bash


# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi


file="$1"


# Replace "void symbolic_longlong_and_int0(size_t len) {" with "void symbolic_longlong_and_int0(long long len) {"
sed -i -E 's/(^|[^a-zA-Z0-9_])size_t([^a-zA-Z0-9_]|$)/\1long long\2/g' "$file"