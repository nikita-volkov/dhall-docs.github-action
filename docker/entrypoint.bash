#!/bin/bash -e

dhall-docs --input "$input" --package-name "$package_name"

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

# Add repository reference if requested
if [ "$add_repo_reference" = "true" ]; then
  echo "Adding repository reference to documentation..."
  
  # Get short commit hash (first 7 characters)
  if [ -n "$github_sha" ]; then
    short_sha="${github_sha:0:7}"
    generation_time=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
    
    # Prepare the repository URL
    repo_url="${github_server_url}/${github_repository}/tree/${github_sha}"
    
    echo "Commit: $short_sha"
    echo "Generated: $generation_time"
    echo "Repository URL: $repo_url"
    
    # Add repository reference with short commit hash and timestamp to HTML files
    # Using @ as delimiter to avoid conflicts with / in URLs and | in attributes
    replacement_html="<a id=\"switch-light-dark-mode\" class=\"nav-option\">Switch Light/Dark Mode</a> <a href=\"${repo_url}\" target=\"_blank\" title=\"Commit: ${short_sha} - Generated: ${generation_time}\" class=\"nav-option\">${short_sha}</a> <span class=\"nav-option\" style=\"font-size: 0.8em; opacity: 0.7;\">${generation_time}</span>"
    find "docs" -name "*.html" -type f -exec sed -i "s@<a id=\"switch-light-dark-mode\" class=\"nav-option\">Switch Light/Dark Mode</a>@${replacement_html}@g" {} \;
    
    # Check if any HTML files were modified
    html_count=$(find "docs" -name "*.html" -type f | wc -l)
    if [ "$html_count" -gt 0 ]; then
      echo "Repository reference added to $html_count HTML file(s)"
    else
      echo "Warning: No HTML files found in docs directory"
    fi
  else
    echo "Warning: github_sha not available, skipping repository reference"
  fi
fi

# Set GitHub Actions output to the docs directory (relative to workspace)
echo "path=docs" >> "$GITHUB_OUTPUT"
echo "Set output path to: docs"
