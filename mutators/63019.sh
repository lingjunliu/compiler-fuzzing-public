#!/bin/bash


# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi


file="$1"


# Replace "%hhu" with "%d"
sed -i -E 's/%hhu/%d/g' "$file"