#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# 
memcpys=$(grep -noE '__builtin_memcpy\(\&[a-zA-Z_][a-zA-Z0-9_]*, \&[a-zA-Z_][a-zA-Z0-9_]*, sizeof\([a-zA-Z_][a-zA-Z0-9_]*\)\);' "$file" | \
sed -E "s/__builtin_memcpy\(\&([a-zA-Z_][a-zA-Z0-9_]*), \&([a-zA-Z_][a-zA-Z0-9_]*), sizeof\(([a-zA-Z_][a-zA-Z0-9_]*)\)\);/\1:\2:\3/")

if [ -z "$memcpys" ]; then
  echo "No matching patterns found."
  exit 0
fi

memcpy=$(echo "$memcpys" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

line=$(echo "$memcpy" | cut -d: -f1)
var1=$(echo "$memcpy" | cut -d: -f2)
var2=$(echo "$memcpy" | cut -d: -f3)
type=$(echo "$memcpy" | cut -d: -f4)

sed -i -E "$line s/__builtin_memcpy\(\&[a-zA-Z_][a-zA-Z0-9_]*, \&[a-zA-Z_][a-zA-Z0-9_]*, sizeof\([a-zA-Z_][a-zA-Z0-9_]*\)\);//" "$file"
sed -i -E "s/$type $var1;/$type $var1 = \($type\)$var2;/" "$file"