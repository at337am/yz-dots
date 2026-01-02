#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途: 列出当前路径下所有视频的时长 (按时长从小到大排序)
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

set -euo pipefail

# 依赖检查
dependencies=("mediainfo" "fd")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

printf "Listing MP4 durations...\n"

fd -IH -e mp4 -d 1 -0 | while IFS= read -r -d $'\0' file; do
    mediainfo --Inform=$'General;%Duration%\t%FileName%.%FileExtension%\t%Duration/String3%' "$file"
done | sort -n | cut -f2-
