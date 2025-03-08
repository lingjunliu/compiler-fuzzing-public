#!/bin/bash

# Check if both file and seed arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
seed="$2"

# Find all lines containing asm("a[0-9]+") with line numbers
matches=$(grep -n 'asm("a[0-9]\+")' "$file")

# If no matches are found, exit
if [ -z "$matches" ]; then
    echo "No asm(\"a[number]\") found."
    exit 0
fi

# Randomly select one match based on the seed
random_match=$(echo "$matches" | awk -v seed="$seed" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

# Extract the line number and the full match
line_number=$(echo "$random_match" | cut -d: -f1)
full_match=$(echo "$random_match" | cut -d: -f2-)

# Extract the specific asm("a[number]") to replace
asm_pattern=$(echo "$full_match" | grep -o 'asm("a[0-9]\+")')

# Replace the selected asm("a[number]") with asm("sp") on that line
sed -i "${line_number}s/${asm_pattern}/asm(\"sp\")/" "$file"

echo "Changed ${asm_pattern} to asm(\"sp\") on line ${line_number}"
