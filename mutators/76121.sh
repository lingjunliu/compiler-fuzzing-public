#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"
SEED=$2

# Read in the entire if statement
ifWhole=$(grep -zoE "if \([a-zA-Z_][a-zA-Z0-9_]*\) \{[^}]*__kmpc_fork_call\([a-zA-Z_][a-zA-Z0-9_]*, [0-9]+, [a-zA-Z_][a-zA-Z0-9_]*, [a-zA-Z_][a-zA-Z0-9_]*\);[^}]*\} else \{[^}]*\}" "$file" | \
tr '\0' '\n' | tr -d '\n') 

if [ -z "$ifWhole" ]; then
  echo "No matching patterns found."
  exit 0
fi

ifStatement=$(echo "$ifWhole" | awk -v seed="$SEED" 'BEGIN {srand(seed); line=""} {if (rand() <= 1/NR) line=$0} END {print line}')

# Save the name of the variable used
cond=$(echo "$ifStatement" | grep -oE "if \([a-zA-Z_][a-zA-Z0-9_]*\) \{" | \
sed -E "s/if \(([a-zA-Z_][a-zA-Z0-9_]*)\) \{/\1/")

# Add if and cond to kmpc_fork_call and delete the next 3 lines
sed -i -E "/__kmpc_fork_call(\([a-zA-Z_][a-zA-Z0-9_]*, [0-9]+, [a-zA-Z_][a-zA-Z0-9_]*,) ([a-zA-Z_][a-zA-Z0-9_]*\);)/{
  s/__kmpc_fork_call(\([a-zA-Z_][a-zA-Z0-9_]*, [0-9]+, [a-zA-Z_][a-zA-Z0-9_]*,) ([a-zA-Z_][a-zA-Z0-9_]*\);)/__kmpc_fork_call_if\1 $cond, \2/
  p
  N
  N
  N
  d
}
!p
" "$file"

# Delete the if statement 
sed -i -E "s/if \($cond\) \{//" "$file"

# Add cond and args to _kmpc_fork_call_if 
sed -i -E "s/extern void __kmpc_fork_call\((ident_t \*[a-zA-Z_][a-zA-Z0-9_]*, kmp_int32 [a-zA-Z_][a-zA-Z0-9_]*, kmpc_micro [a-zA-Z_][a-zA-Z0-9_]*,) \.\.\.\);/\
extern void __kmpc_fork_call_if\(\1 kmp_int32 $cond, void \*args\);/" "$file"



