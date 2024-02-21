#!/bin/bash

# Array of allowed file extensions
declare -a allowed_extensions=("js" "html" "css")

# Array of sensitive variables
declare -a sensitive_variables=("API_KEY" "PASSWORD" "SECRET")

# Flag to track if sensitive variables are found
found_sensitive_variables=false

# Function to recursively list files and search for sensitive variables
list_files() {
    local dir="$1"
    local file
    # Loop through files and directories in the current directory
    for file in "$dir"/*; do
        # Check if the current item is a directory and not "node_modules"
        if [[ -d "$file" && "$file" != *"node_modules"* ]]; then
            # If it's a directory, recursively list its contents
            list_files "$file"
        elif [[ -f "$file" ]]; then
            # If it's a regular file and has an allowed extension, search for sensitive variables
            extension="${file##*.}"
            if [[ " ${allowed_extensions[@]} " =~ " ${extension} " ]]; then
                echo "Searching for sensitive variables in $file:"
                line_number=0
                while IFS= read -r line; do
                    ((line_number++))
                    for variable in "${sensitive_variables[@]}"; do
                        if grep -Eq "^(\s+)?(var|let|const)\s+(${variable})\s*=" <<< "$line" && ! grep -Eq "process\.env\.(${variable})" <<< "$line"; then
                            echo "Line $line_number: $line"
                            found_sensitive_variables=true
                        fi
                    done
                done < "$file"
                echo "------------------------"
            fi
        fi
    done
}

# Start searching for sensitive variables from the current directory
list_files "."

# Exit with appropriate status based on whether sensitive variables are found
if $found_sensitive_variables; then
    exit 1
else
    exit 0
fi
