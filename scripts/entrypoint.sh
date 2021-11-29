#!/bin/bash --login
echo "in entrypoint.sh"

echo "$@"

conda run -n analysis --no-capture-output "$@"
