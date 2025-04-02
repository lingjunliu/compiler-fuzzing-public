#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Read in the entire if statement
ifWhole=$(grep -zoE "if \([a-zA-Z_][a-zA-Z0-9_]*\) \{[^}]*__kmpc_fork_call\(.*, .*, .*, .*\);" "$file" | \
tr '\0' '\n' | tr -d '\n') 

if [ -z "$ifWhole" ]; then
  echo "No matching patterns found."
  exit 0
fi

ifStatement=$(echo "$ifWhole" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

# Save the name of the variable used
cond=$(echo "$ifStatement" | grep -oE "if \([a-zA-Z_][a-zA-Z0-9_]*\) \{" | \
sed -E "s/if \(([a-zA-Z_][a-zA-Z0-9_]*)\) \{/\1/")

# Add cond and args to _kmpc_fork_call_if 
sed -i -E "s/extern void __kmpc_fork_call\((.*, .*, .*,) \.\.\.\)/\
extern void __kmpc_fork_call_if\(\1 kmp_int32 $cond, void \*args\)/" "$file"

# Add cond and args to _kmpc_fork_call_if 
sed -i -E "s/__kmpc_fork_call\((.*, .*, .*,) (.*)\);/\
__kmpc_fork_call_if\(\1 $cond, \2\);/" "$file"

# Delete the if statement
if=$(grep -noE "if \($cond\)" "$file")
start_line=$(echo "$if" | cut -d: -f1)
echo $start_line
current_line=0
in_block=0

> tmp  # clear output
echo >> "$file"
while IFS= read -r line; do
  ((current_line++))

  # Start skipping from the if-line
  if [[ $current_line -eq $start_line ]]; then
    in_block=1
    echo $current_line
    continue
  fi

  if [[ $in_block -eq 1 ]]; then
    # Save __kmpc_fork_call line even if inside block
    # if [[ $line =~ __kmpc_fork_call_if\(.*\) ]]; then
    #   echo "$line" >> tmp
    #   continue
    # fi

    # Stop skipping after first closing brace line
    if [[ $line =~ ^[[:space:]]*\} ]]; then
      in_block=0
      # If the line contains else, variable = 1 until another curly brace found
      continue  # DO NOT print this closing brace (ends the if)
    # else
    #   echo "$line" >> tmp
    fi

    # continue  # Skip everything else in block
  fi

  echo "$line" >> tmp
done < "$file"

# echo "}" >> tmp

mv tmp "$file"