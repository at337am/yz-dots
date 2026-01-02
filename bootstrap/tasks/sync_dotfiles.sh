#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "rsync" &> /dev/null; then
    printf "Error: Missing dependency: rsync\n" >&2
    exit 1
fi

DOTS_PATH="/workspace/dev/yz-dots/home"

if [[ ! -d "$DOTS_PATH" ]]; then
    printf "Error: %s does not exist.\n" "$DOTS_PATH" >&2
    exit 1
fi

# 执行同步
rsync -a "$DOTS_PATH/" ~/
