#!/bin/bash

input_file="$1"
output_file="$2"

sed -E -e 's/unsigned _BitInt\(([0-9]+)\) ([a-zA-Z_][a-zA-Z0-9_]*) = (0x[a-zA-Z0-9_]*);/return \3;/' -e '/return \(float\)([a-zA-Z_][a-zA-Z0-9_]*)/d' "$input_file" > "$output_file"