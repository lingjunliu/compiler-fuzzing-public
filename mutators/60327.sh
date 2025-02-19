#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Find all the long declarations and save line numbers + var name + what it's equal to
longVars=$(grep -noE "long [a-zA-Z_][a-zA-Z0-9_]* = [0-9]+;" "$file" | \
sed -E 's/long ([a-zA-Z_][a-zA-Z0-9_]*) = ([0-9]+);/\1:\2'/)

if [ -z "$longVars" ]; then
  echo "No matching patterns found."
  exit 0
fi

# Randomly pick a random declaration
random_match1=$(echo "$longVars" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
declarLine=$(echo "$random_match1" | cut -d: -f1)
longVar=$(echo "$random_match1" | cut -d: -f2)
equalTo=$(echo "$random_match1" | cut -d: -f3)

# Delete the declaration
sed -i -E "${declarLine} s/long [a-zA-Z_][a-zA-Z0-9_]* = [0-9]+;//" "$file"

# Find pointer declarations where the pointers are initialized to longVar
pointers=$(grep -noE "long \*[a-zA-Z_][a-zA-Z0-9_]* = \&${longVar};" "$file" | \
sed -E "s/long \*([a-zA-Z_][a-zA-Z0-9_]*) = \&${longVar};/\1"/)

if [ -z "$pointers" ]; then
  echo "No matching patterns found."
  exit 0
fi

# Randomly pick a pointer declaration 
random_match2=$(echo "$pointers" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')
pointerLine=$(echo "$random_match2" | cut -d: -f1)
pointer=$(echo "$random_match2" | cut -d: -f2)

# Replace the pointer declaration with long <pointerName> = <equalTo>
sed -i -E "${pointerLine} s/long \*[a-zA-Z_][a-zA-Z0-9_]* = \&${longVar};/long ${pointer} = ${equalTo};/" "$file"

# Replace any reference to the pointer with the new variable
sed -i -E "s/([^a-zA-Z0-9_])\*${pointer}([^a-zA-Z0-9_])/\1${pointer}\2/g" "$file"
