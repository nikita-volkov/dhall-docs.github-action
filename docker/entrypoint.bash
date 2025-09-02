#!/bin/bash -e

function main {
  dhall-docs --input "$input" --output-link docs
  
  # Get the target path of the symlink created by dhall-docs
  if [ -L "docs" ]; then
    local docs_path
    docs_path=$(readlink -f "docs")
    echo "Documentation generated successfully at: $docs_path"
    
    # Set GitHub Actions output
    echo "path=$docs_path" >> "$GITHUB_OUTPUT"
  else
    echo "Error: Expected 'docs' to be a symlink, but it's not."
    return 1
  fi
}

# Run main function and capture exit code
main
exit_code=$?

# Set action output based on success/failure
if [ $exit_code -eq 0 ]; then
  echo "Documentation generated successfully"
else
  echo "Documentation generation failed"
fi

# Exit with the same code as main function
exit $exit_code
