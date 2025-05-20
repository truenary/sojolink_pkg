#!/bin/bash

# Function to update version in the specified file
update_version() {
    local file=$1
    local version=$2

    # Check if the file or version is empty
    if [ -z "$file" ] || [ -z "$version" ]; then
        echo "Usage: $0 <file.extension> <version>"
        exist 1
    fi

    # Check if the specified file exists
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found!"
        exist 1
    fi

    # Update the version in the specific file
    if ! sed -i.bak "s/^version: .*/version: $version/" "$file"; then
        echo "Error: Failed to update version in $file"
        exist 1
    fi

    echo "Updated version to $version in $file"
}
# Call the function with arguments passed to the script
update_version "$@"