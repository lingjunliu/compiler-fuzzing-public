#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E 's/([^0-9])[0-9][0-9][0-9]([^0-9])/\166666666666666666666wb\2/g' "$file"
