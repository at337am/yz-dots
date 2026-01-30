#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "ffmpeg" &> /dev/null; then
    printf "Error: Missing dependency: ffmpeg\n" >&2
    exit 1
fi

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <video>\n" "$(basename "$0")" >&2
    exit 1
fi

VID_PATH="$1"

if [[ ! -f "$VID_PATH" ]]; then
    printf "Error: %s does not exist.\n" "$VID_PATH" >&2
    exit 1
fi

# 构建输出文件名
ext="${VID_PATH##*.}"
output_path="${VID_PATH%.*}_noaudio.$ext"

# 去除音频流
ffmpeg -i "$VID_PATH" -c:v copy -an -y "$output_path"

printf "Done.\n"
