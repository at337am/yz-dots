#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途：
# 该脚本用于在当前目录（深度 1）中查找所有 MP4 文件，
# 并列出它们的时长（毫秒和可读格式）以及文件名。
# 输出结果按视频时长从短到长排序，方便快速查看和比较视频长度。
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
