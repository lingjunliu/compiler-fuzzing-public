#!/bin/bash


# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi


file="$1"


# Replace "a == 0 ? 64 : " with ""
sed -i -E 's/return ([a-zA-Z_][a-zA-Z_0-9]*) == [0-9]+ \? [0-9]+ : ([a-zA-Z_][a-zA-Z_0-9]*)\(\1\);/return \2(\1);/' "$file"