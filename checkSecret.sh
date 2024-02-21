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
    FILES_WITH_SENSITIVE_VARIABLES=$(grep -rnw . -e "${SENSITIVE_VARIABLES[@]}" --include="*.${EXTENSION}" 2>/dev/null)
    if [ -n "$FILES_WITH_SENSITIVE_VARIABLES" ]; then
        # Print files and lines containing sensitive variables
        echo "Exposed sensitive variables found in ${EXTENSION} files:"
        echo "$FILES_WITH_SENSITIVE_VARIABLES"
        EXPOSED_VARIABLES_FOUND=true
    fi
done

# Return appropriate exit code based on whether exposed variables are found
if $EXPOSED_VARIABLES_FOUND; then
    exit 1
else
    exit 0
fi
