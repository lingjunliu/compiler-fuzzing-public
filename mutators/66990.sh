#!/bin/bash


# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi


file="$1"

# Do p first
sed -i -E 's/const char \*const (p) =/const char *\1 =/g' "$file"

# Then q
sed -i -E 's/const char \*const (q) =/const char *\1 =/g' "$file"

# Add a line
sed -i -E 's/(clang_analyzer_dump\(strlen\(q\)\));/clang_analyzer_dump(\n    strlen(q)); /g' "$file"
