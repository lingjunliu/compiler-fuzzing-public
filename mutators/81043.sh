#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

# Remove the target_clones attribute and break it into separate target_version attributes
sed -E -i 's/__attribute__\(\(target_clones\("([a-zA-Z0-9_]+)", "([a-zA-Z0-9_]+)", "([a-zA-Z0-9_]+)"\)\)\)/__attribute__((target_version("\1")))\n__attribute__((target_version("\2")))\n__attribute__((target_version("\3")))/' "$file"