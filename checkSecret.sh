#!/bin/bash

# Define sensitive variable patterns to search for
SENSITIVE_VARIABLES=("PASSWORD" "SECRET" "TOKEN")

# Define source file extensions to scan
SOURCE_FILE_EXTENSIONS=("js" "ts" "html" "css" "json" "yaml" "yml")

# Initialize variable to track if exposed variables are found
EXPOSED_VARIABLES_FOUND=false

# Loop through each source file extension
for EXTENSION in "${SOURCE_FILE_EXTENSIONS[@]}"; do
    # Find all files with the current extension and search for sensitive variables
    echo "$EXTENTION"
    while IFS= read -r LINE; do
        # Check if the line contains variable declaration
        if [[ "$LINE" =~ \b(var|let|const)\s+(${SENSITIVE_VARIABLES[@]})\b ]]; then
            # Check if the variable is assigned a value directly and not to process.env
            echo "First if ${LINE}"
            if ! [[ "$LINE" =~ \b(var|let|const)\s+(${SENSITIVE_VARIABLES[@]})\s*=\s*process\.env\.${SENSITIVE_VARIABLES[@]} ]]; then
                echo "Second if ${LINE}"
                if ! [[ "$LINE" =~ \b(var|let|const)\s+(${SENSITIVE_VARIABLES[@]})\s*=\s*['"']\w*['"'] ]]; then
                    # Print files and lines containing sensitive variables
                    echo "Exposed sensitive variable found in ${EXTENSION} files:"
                    echo "$LINE"
                    # Set the flag to true if sensitive variables are found
                    EXPOSED_VARIABLES_FOUND=true
                fi
            fi
        fi
    done < <(grep -rnw . --include="*.${EXTENSION}" -e "${SENSITIVE_VARIABLES[@]}" 2>/dev/null)
done

# Return appropriate exit code based on whether exposed variables are found
if $EXPOSED_VARIABLES_FOUND; then
    exit 1
else
    exit 0
fi
