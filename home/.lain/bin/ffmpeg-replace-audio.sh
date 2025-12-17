#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途: 替换视频的音频轨道, 取最短
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

set -euo pipefail

# 依赖检查
if ! command -v "ffmpeg" &> /dev/null; then
    printf "Error: Missing dependency: ffmpeg\n" >&2
    exit 1
fi

if [[ "$#" -ne 2 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <video> <audio>\n" "$(basename "$0")" >&2
    exit 1
fi

VID_PATH="$1"
AUD_PATH="$2"

# 检查输入文件是否存在
if [[ ! -f "$VID_PATH" ]]; then
    printf "Error: %s does not exist.\n" "$VID_PATH" >&2
    exit 1
fi
if [[ ! -f "$AUD_PATH" ]]; then
    printf "Error: %s does not exist.\n" "$AUD_PATH" >&2
    exit 1
fi

# 构建输出格式
output_dir=$(dirname "$VID_PATH")
video_base=$(basename "$VID_PATH")
video_name="${video_base%.*}"
ext="${video_base##*.}"

output_path="$output_dir/${video_name}_repaudio.$ext"

# -shortest: 当最短的输入流结束时，完成编码
ffmpeg -hide_banner -loglevel error \
    -i "$VID_PATH" \
    -i "$AUD_PATH" \
    -c:v copy \
    -c:a copy \
    -map 0:v \
    -map 1:a \
    -shortest \
    -y "$output_path"

if [[ "$?" -eq 0 ]]; then
    printf "OK -> %s\n" "$output_path"
else
    printf "ERR -> %s\n" "$output_path" >&2
    exit 1
fi
