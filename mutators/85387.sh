#!/bin/bash

input_file="$1"
output_file="$2"

sed -E 's/typedef ([a-zA-Z_][ a-zA-Z0-9_]*) ([a-zA-Z_][a-zA-Z0-9_]*);/typedef \1 \2 __attribute__((aligned(4)));/' "$input_file" > "$output_file"
