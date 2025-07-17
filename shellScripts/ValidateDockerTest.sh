#!/bin/bash

TEST="/volume/JenkinsBase/docker/Results"
GOLD="/volume/JenkinsBase/docker/Gold"

# Run JTCompare inside Docker and capture the result
docker exec jtcompare_container /bin/bash /volume/jtcompare/JTCompare_1.0.2/runcompare.sh "${GOLD}" "${TEST}"
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo "❌ JT Comparison failed."
    exit 1
else
    echo "✅ JT Comparison passed."
    exit 0
fi