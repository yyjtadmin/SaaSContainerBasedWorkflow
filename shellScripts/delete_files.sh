#!/bin/bash

# Check if input file is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"
START_DIR="$(pwd)"

echo "lookupdir: $START_DIR"

# Check if file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Provide a valid input text file"
    exit 1
fi

# Read file line by line
while IFS= read -r filename
do
    # Skip empty lines
    filename=$(echo "$filename" | xargs)
    if [ -z "$filename" ]; then
        continue
    fi

    echo "Looking for: $filename"

    # Find and delete matching files
    find "$START_DIR" -type f -name "$filename" | while read -r file
    do
        echo "file to remove: $file"
        rm -f "$file"
    done

done < "$INPUT_FILE"