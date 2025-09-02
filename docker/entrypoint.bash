#!/bin/bash -e

# Working directory is automatically /github/workspace (the mounted workspace)
echo "Working in: $(pwd)"

# Generate docs with symlink in workspace
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

# Create docs directory in workspace
mkdir "docs"
echo "Created directory 'docs'"

# Copy contents from target to docs directory
if [ -d "$docs_path" ] && [ "$(ls -A "$docs_path")" ]; then
  cp -r "$docs_path"/* "docs"/
  echo "Copied contents from $docs_path to docs directory"
else
  echo "Warning: Source directory $docs_path is empty or doesn't exist"
fi

# Upload as artifact if requested
if [ "$upload_artifact" = "true" ]; then
  echo "Uploading documentation as workflow artifact..."
  # Note: This requires actions/upload-artifact to be available in the workflow
  echo "To upload as artifact, use actions/upload-artifact@v3 in your workflow with path: docs"
fi

# Set GitHub Actions output to the docs directory (relative to workspace)
echo "path=docs" >> "$GITHUB_OUTPUT"
echo "Set output path to: docs (relative to workspace)"
