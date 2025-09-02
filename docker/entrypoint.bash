#!/bin/bash -e

function main {
  dhall-docs --input "$input" --output-link docs
  
  # Get the target path of the symlink created by dhall-docs
  if [ -L "docs" ]; then
    local docs_path
    docs_path=$(readlink -f "docs")
    echo "Documentation generated successfully at: $docs_path"
    
    # Remove the symlink
    rm "docs"
    echo "Removed symlink 'docs'"
    
    # Create docs directory
    mkdir "docs"
    echo "Created directory 'docs'"
    
    # Copy contents from target to docs directory
    if [ -d "$docs_path" ] && [ "$(ls -A "$docs_path")" ]; then
      cp -r "$docs_path"/* "docs"/
      echo "Copied contents from $docs_path to docs directory"
    else
      echo "Warning: Source directory $docs_path is empty or doesn't exist"
    fi
    
    # Set GitHub Actions output to the docs directory
    local current_dir
    current_dir=$(pwd)
    echo "path=$current_dir/docs" >> "$GITHUB_OUTPUT"
    echo "Set output path to: $current_dir/docs"
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
