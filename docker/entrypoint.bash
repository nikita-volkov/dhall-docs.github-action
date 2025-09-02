#!/bin/bash -e

# Function to convert a symlink to a real directory by moving the target contents
function convert_symlink_to_dir {
    local SYMLINK="$1"

    # Get the target path of the symlink
    local TARGET_DIR
    TARGET_DIR=$(readlink -f "$SYMLINK")

    # Check if the input is a symlink
    if [ ! -L "$SYMLINK" ]; then
        echo "Error: '$SYMLINK' is not a symbolic link or does not exist."
        return 1
    fi

    # Check if the target directory exists
    if [ ! -d "$TARGET_DIR" ]; then
        echo "Error: Target directory '$TARGET_DIR' does not exist."
        return 1
    fi

    # Check write permissions for the current directory and target
    if [ ! -w "$(dirname "$SYMLINK")" ]; then
        echo "Error: No write permission in the directory containing '$SYMLINK'. Try running with sudo."
        return 1
    fi
    if [ ! -w "$TARGET_DIR" ]; then
        echo "Error: No write permission for target directory '$TARGET_DIR'. Try running with sudo."
        return 1
    fi

    # Remove the symlink
    echo "Removing symlink '$SYMLINK'..."
    rm "$SYMLINK"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to remove symlink '$SYMLINK'."
        return 1
    fi

    # Move the target directory to the symlink's name
    echo "Moving contents from '$TARGET_DIR' to new directory '$SYMLINK'..."
    mv "$TARGET_DIR" "$SYMLINK"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to move '$TARGET_DIR' to '$SYMLINK'."
        return 1
    fi

    # Verify the new directory
    if [ -d "$SYMLINK" ]; then
        echo "Success: '$SYMLINK' is now a real directory with the target contents."
        ls -lha --color=auto | grep "$SYMLINK"
        return 0
    else
        echo "Error: Failed to create directory '$SYMLINK'."
        return 1
    fi
}

function main {
  dhall-docs --input "$input" --output-link docs
  convert_symlink_to_dir docs
}

# Run main function and capture exit code
main
exit_code=$?

# Set action output based on success/failure
if [ $exit_code -eq 0 ]; then
  echo "name=output::Documentation generated successfully" >> $GITHUB_OUTPUT
else
  echo "name=output::Documentation generation failed" >> $GITHUB_OUTPUT
fi

# Exit with the same code as main function
exit $exit_code
