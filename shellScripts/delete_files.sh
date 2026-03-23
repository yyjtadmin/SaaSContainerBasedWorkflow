#!/bin/bash

# Enable debug
set -o errexit   # exit on error
set -o pipefail  # catch pipe errors
set -o nounset   # undefined variable error
set -x           # 🔥 print each command (very useful)

echo "===== DEBUG: Script Started ====="

# Check if input file is provided
if [ $# -lt 1 ]; then
    echo "ERROR: No input file provided"
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"
START_DIR="$(pwd)"

echo "DEBUG: Input file = $INPUT_FILE"
echo "DEBUG: Start directory = $START_DIR"

# Check if file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "ERROR: Input file does not exist: $INPUT_FILE"
    exit 1
fi

echo "===== DEBUG: Input file content ====="
cat "$INPUT_FILE" || true
echo "===================================="

TOTAL_FOUND=0
TOTAL_DELETED=0

# Read file line by line
while IFS= read -r filename
do
    echo "------------------------------------"
    echo "DEBUG: Raw line = '$filename'"

    # Trim spaces
    filename=$(echo "$filename" | xargs)

    echo "DEBUG: Trimmed filename = '$filename'"

    # Skip empty lines
    if [ -z "$filename" ]; then
        echo "DEBUG: Skipping empty line"
        continue
    fi

    echo "Looking for: $filename"

    MATCH_COUNT=0

    # Find and delete matching files
    while IFS= read -r file
    do
        echo "DEBUG: Found file = $file"

        if [ -f "$file" ]; then
            echo "file to remove: $file"
            rm -f "$file"
            echo "DEBUG: Deleted: $file"

            MATCH_COUNT=$((MATCH_COUNT + 1))
            TOTAL_DELETED=$((TOTAL_DELETED + 1))
        else
            echo "WARNING: File not found during delete: $file"
        fi
    done < <(find "$START_DIR" -type f -name "$filename")

    echo "DEBUG: Files matched for '$filename' = $MATCH_COUNT"
    TOTAL_FOUND=$((TOTAL_FOUND + MATCH_COUNT))

done < "$INPUT_FILE"

echo "===== DEBUG: Summary ====="
echo "Total files matched: $TOTAL_FOUND"
echo "Total files deleted: $TOTAL_DELETED"
echo "===== DEBUG: Script Completed ====="