#!/bin/bash

# Environment setup function
SetUpEnvironment() {
    export LC_ALL="en_US.utf8"
    export SPLM_LICENSE_SERVER="/volume/jtcompare/License/ugslmd_license.lic"
    export JT_COMPARE_INSTALL="/volume/jtcompare/JTCompare_1.0.2"
}

# Check argument count early
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <GOLD_JT folder path> <RESULT_JT folder path>"
    exit 1
fi

SOURCE_dir="$1"
RESULT_dir="$2"
sDirSeparator="/"

# Set up environment
SetUpEnvironment

# Validate environment variables
if [[ -z "$SPLM_LICENSE_SERVER" ]]; then
    echo "Error: SPLM_LICENSE_SERVER environment variable is not set."
    exit 1
fi

if [[ -z "$JT_COMPARE_INSTALL" ]]; then
    echo "Error: JT_COMPARE_INSTALL environment variable is not set."
    exit 1
fi

# Create temporary directory for comparison results
tmpdir="${RESULT_dir}${sDirSeparator}.tempdir"
mkdir -p "$tmpdir"

# Change to JT_COMPARE_INSTALL directory
cd "$JT_COMPARE_INSTALL" || { echo "Error: Cannot change to directory $JT_COMPARE_INSTALL"; exit 1; }

current_working_dir=$(pwd)
echo "Current working directory: $current_working_dir"
jt_compare_call="${current_working_dir}${sDirSeparator}run_jtcompare"

# Run JT compare for each .jt file
for file in "$SOURCE_dir"/*.jt; do
    [[ -e "$file" ]] || continue  # Skip if no .jt files exist
    filename=$(basename "$file")
    gold_jt_file="$SOURCE_dir/$filename"
    result_jt_file="$RESULT_dir/$filename"
    exe_call="$jt_compare_call -gold \"$gold_jt_file\" -test \"$result_jt_file\""
    echo "Running: $exe_call"
    eval "$exe_call"
done

# Check if any JTIC_* files were generated
shopt -s nullglob
jtic_files=("$tmpdir"/JTIC_*)
shopt -u nullglob

if [[ ${#jtic_files[@]} -eq 0 ]]; then
    echo "Error: No JTIC_* result files found in '$tmpdir'. JT comparison might have failed or did not run."
    exit 2
fi

# Parse results
ResultArray=()
for file in "${jtic_files[@]}"; do
    echo "Checking result: $file"
    class_status=$(xmllint --xpath "string(//TestCase/@class)" "$file" 2>/dev/null)
    if [[ "$class_status" != "Pass" ]]; then
        ResultArray+=("$(basename "$file")")
    fi
done

# Summary
nFailedCases=${#ResultArray[@]}
echo
echo "*==== Result Summary ====*"
if (( nFailedCases != 0 )); then
    echo "$nFailedCases case(s) failed in JT Comparison:"
    for failed in "${ResultArray[@]}"; do
        echo "  - $failed"
    done
    exit 1
else
    echo "All cases passed in JT Comparison."
    exit 0
fi
