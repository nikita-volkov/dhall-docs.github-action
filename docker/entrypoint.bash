#!/bin/bash -e

dhall-docs --input "$input" --output-link docs

# Check if docs is a symlink (early termination if not)
if [ ! -L "docs" ]; then
  echo "Error: Expected 'docs' to be a symlink, but it's not."
  exit 1
fi

# Get the target path of the symlink created by dhall-docs
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
current_dir=$(pwd)
echo "path=$current_dir/docs" >> "$GITHUB_OUTPUT"
echo "Set output path to: $current_dir/docs"
