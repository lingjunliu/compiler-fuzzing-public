#!/bin/bash

input_file="$1"
output_file="$2"

sed -E 's/_BitInt\(([0-9]+)\) ([a-zA-Z_][a-zA-Z0-9_]*);/register _BitInt(\1) \2 asm(\"\");/' "$input_file" > "$output_file"
