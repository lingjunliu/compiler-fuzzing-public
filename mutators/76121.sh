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
# Add newline to prevent missing the final block
echo >> "$file"

# Code + explanation by chat gpt...
# Print lines before the if-statement
# Skip the if (...) { line
# If we find } else {, end the if block and begin skipping the if-block
# Match a line that is just a closing brace, skip the line
# While inside the if block, print the contents
# After we're out of block, print all remaining lines as normal
awk -v start="$start_line" '
NR < start { print; next }

NR == start {
    in_if = 1
    next
}

/\}[ \t]*else[ \t]*\{/ && in_if {
    in_if = 0
    in_else = 1
    next
}

/^[ \t]*}[ \t]*$/ {
    if (in_if) {
        in_if = 0
        next
    }
    if (in_else) {
        in_else = 0
        next
    }
}

(in_if && !in_else) {
    print
    next
}

(!in_if && !in_else) {
    print
}
' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
