#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Check arguments
if [ $# -lt 2 ]; then
    echo "ERROR: Missing arguments"
    echo "Usage: $0 <input_file> <stage_dir>"
    exit 1
fi

INPUT_FILE="$1"
START_DIR="$2"

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

TOTAL_FOUND=0
TOTAL_DELETED=0

# Read file line by line
while IFS= read -r filename
do
    filename=$(echo "$filename" | xargs)

    if [ -z "$filename" ]; then
        continue
    fi

    MATCH_COUNT=0

    while IFS= read -r file
    do
        if [ -f "$file" ]; then
            rm -f "$file"
            MATCH_COUNT=$((MATCH_COUNT + 1))
            TOTAL_DELETED=$((TOTAL_DELETED + 1))
        fi
    done < <(find "$START_DIR" -type f -name "$filename")

    TOTAL_FOUND=$((TOTAL_FOUND + MATCH_COUNT))

done < "$INPUT_FILE"