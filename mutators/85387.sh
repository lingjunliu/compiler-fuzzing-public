#!/bin/bash

input_file="$1"
output_file="$2"

sed -E 's/typedef long long Tal4llong;/typedef long long Tal4llong __attribute__((aligned(4)));/' "$input_file" > "$output_file"
