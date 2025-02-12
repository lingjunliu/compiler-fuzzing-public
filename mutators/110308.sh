#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

#random struct
#structName s; --> structName();
sed -i -E 's/(void encodeBlock\(\) \{ ms_adpcm_state) [a-zA-Z_][a-zA-Z0-9_]*(; \})/\1\(\)\2/' "$file"