#!/usr/bin/env bash

set -euo pipefail

echo "Starting Go environment configuration..."

go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct

echo "Go environment configuration complete."

echo "Preparing to install skit..."

if [[ ! -d "$HOME/workspace/dev/skit" ]]; then
    echo "Error: skit directory does not exist!"
    exit 1
fi

(
    cd "$HOME/workspace/dev/skit" && \
    just install-all
)
