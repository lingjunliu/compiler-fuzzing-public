#!/bin/bash


# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi


file="$1"


# Update mutex acquire and acquired callback function conditions (handling multi-line patterns)
# :a;N;$!ba: reads the entire input into memory by concatenating all lines into the pattern space.
sed -i -E ':a;N;$!ba;s/if \(kind == ompt_mutex_test_lock \|\| kind == ompt_mutex_lock \|\|\n *kind == ompt_mutex_test_nest_lock \|\| kind == ompt_mutex_nest_lock\)/if (kind == ompt_mutex_test_lock || kind == ompt_mutex_test_nest_lock)/g' "$file"

# Add a comment to the return statement 
sed -i -E 's/return 1;/return 1; \/\* non-zero indicates success *\//g' "$file"