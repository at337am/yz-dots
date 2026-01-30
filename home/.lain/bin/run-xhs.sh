#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "uv" &> /dev/null; then
    printf "Error: Missing dependency: uv\n" >&2
    exit 1
fi

TARGET_DIR="/opt/soft/XHS-Downloader"

if [[ ! -d "$TARGET_DIR" ]]; then
    printf "Error: %s does not exist.\n" "$TARGET_DIR" >&2
    exit 1
fi

cd "$TARGET_DIR"

# 如果有参数, 则清除下载记录
if [[ "$#" -eq 1 && "$1" == "clear" ]]; then

    rm -rfv \
    Volume/ExploreID.db \
    Volume/MappingData.db \
    Volume/Download/ExploreData.db \
    Volume/Temp

    printf "Done.\n"
    exit 0
fi

uv run python main.py

printf "Done.\n"
