#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

matches=$(grep -oE 'int [a-zA-Z_][a-zA-Z0-9_]*;' "$file" | sed -E 's/int ([a-zA-Z_][a-zA-Z0-9_]*);/\1/' | paste -d ',' - -)

if [ -z "$matches" ]; then
  echo "No matching patterns found."
  exit 0
fi

echo "$matches"
var1=$(echo "$matches" | cut -d, -f1)
var2=$(echo "$matches" | cut -d, -f2)


equivalent1=$(grep -noE "${var1} = (.*);" "$file" | \
sed -E "s/${var1} = (.*);/\1/")

if [ -z "$equivalent1" ]; then
  echo "No matching patterns found."
  exit 0
fi

line1=$(echo "$equivalent1" | cut -d: -f1)
value1=$(echo "$equivalent1" | cut -d: -f2)

equivalent2=$(grep -noE "${var2} = (.*);" "$file" | \
sed -E "s/${var2} = (.*);/\1/")

if [ -z "$equivalent2" ]; then
  echo "No matching patterns found."
  exit 0
fi

line2=$(echo "$equivalent2" | cut -d: -f1)
value2=$(echo "$equivalent2" | cut -d: -f2)

echo "$var1"
echo "$var2"
echo "$value1"
echo "$value2"

sed -i -E "s/int ${var1};/int ${var1} = ${value1}, ${var2} = ${value2};/" "$file"
sed -i -E "s/int ${var2};//" "$file"
sed -i -E "${line1}s/.*//" "$file"
sed -i -E "${line2}s/.*//" "$file"