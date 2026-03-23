#!/bin/bash

# Enable debug
set -o errexit
set -o pipefail
set -o nounset
set -x

echo "===== DEBUG: Script Started ====="

# Check arguments
if [ $# -lt 2 ]; then
    echo "ERROR: Missing arguments"
    echo "Usage: $0 <input_file> <stage_dir>"
    exit 1
fi

INPUT_FILE="$1"
START_DIR="$2"   # 👈 Use stagedir instead of pwd

echo "DEBUG: Input file = $INPUT_FILE"
echo "DEBUG: Start directory (stage dir) = $START_DIR"

# Validate input file
if [ ! -f "$INPUT_FILE" ]; then
    echo "ERROR: Input file does not exist: $INPUT_FILE"
    exit 1
fi

# Validate stage directory
if [ ! -d "$START_DIR" ]; then
    echo "ERROR: Stage directory does not exist: $START_DIR"
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

    filename=$(echo "$filename" | xargs)

    echo "DEBUG: Trimmed filename = '$filename'"

    if [ -z "$filename" ]; then
        echo "DEBUG: Skipping empty line"
        continue
    fi

    echo "Looking for: $filename in $START_DIR"

    MATCH_COUNT=0

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