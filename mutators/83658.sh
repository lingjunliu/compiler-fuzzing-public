#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Read in the entire struct declaration and save it as one line
structWhole=$(grep -zoE "struct [a-zA-Z_][a-zA-Z0-9_]* \{[^}]*\};" "$file" | \
tr '\0' '\n' | tr -d '\n') 

if [ -z "$structWhole" ]; then
  echo "No matching patterns found."
  exit 0
fi

# Choose a random struct
struct=$(echo "$structWhole" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

# Save the struct name as structName
structName=$(echo "$struct" | grep -oE "struct [a-zA-Z_][a-zA-Z0-9_]* \{" | \
sed -E "s/struct ([a-zA-Z_][a-zA-Z0-9_]*) \{/\1/")

# Save the lines inside struct as structContents
structContents=$(echo "$struct" | grep -oE "\{.*\}")

# Delete struct declaration
structFirst=$(grep -noE "struct $structName \{" "$file")
line=$(echo "$structFirst" | cut -d: -f1)
line2=$((line + 1))
line3=$((line2 + 1))

sed -i -E "$line s/struct $structName \{//" "$file"
sed -i -E "$line2 s/.*//" "$file"
sed -i -E "$line3 s/\};//" "$file"

sed -i -E "s/struct $structName([^a-zA-Z0-9_])/struct $structContents\1/" "$file"