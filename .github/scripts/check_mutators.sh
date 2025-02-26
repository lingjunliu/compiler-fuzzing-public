# Loop over all shell scripts in mutators/
for script in mutators/*.sh; do
  # Extract the base name (e.g., 108540 from 108540.sh)
  base=$(basename "$script" .sh)
  input="data/${base}-input.c"
  output="data/${base}-output.c"

  # Check if both input and output files exist
  if [ -f "$input" ] && [ -f "$output" ]; then
    temp_input="temp_${base}.c"
    # Copy the input file to a temporary file
    cp "$input" "$temp_input"

    # Run the mutator script, capturing output and errors
    script_output=$(bash "$script" "$temp_input" 1 2>&1)
    if [ $? -eq 0 ]; then
      # If the script succeeds, diff the result with the expected output
      diff_output=$(diff -u "$temp_input" "$output")
      if [ -z "$diff_output" ]; then
        # No differences found
        echo "## ${base}: No differences" >> $GITHUB_STEP_SUMMARY
      else
        # Differences found, report them in unified diff format
        echo "## ${base}: Differences found" >> $GITHUB_STEP_SUMMARY
        echo '```diff' >> $GITHUB_STEP_SUMMARY
        echo "$diff_output" >> $GITHUB_STEP_SUMMARY
        echo '```' >> $GITHUB_STEP_SUMMARY
      fi
    else
      # Mutator script failed, report the error
      echo "## ${base}: Mutator script failed" >> $GITHUB_STEP_SUMMARY
      echo '```' >> $GITHUB_STEP_SUMMARY
      echo "$script_output" >> $GITHUB_STEP_SUMMARY
      echo '```' >> $GITHUB_STEP_SUMMARY
    fi
    # Clean up the temporary file
    rm "$temp_input"
  else
    # Report missing files
    echo "## ${base}: Missing input or output file" >> $GITHUB_STEP_SUMMARY
  fi
done
