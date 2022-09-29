#!/usr/bin/env bash

# Fail on errors and errors in pipelines.
set -e
set -o pipefail

# Build the module, with the template renamed.
docker build --no-cache -t test-rename-module -f Dockerfile.rename-module-test .
docker run -it test-rename-module | tee rename-module-output.txt

# Assert that tht output of the renamed project is as expected.
if grep --quiet "Package name: test_user/test_project" rename-module-output.txt; then
    echo "Success; output is as expeted."
else
    echo "Error; output does not match as expected."
    exit 1
fi
