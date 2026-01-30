#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "magick" &> /dev/null; then
    printf "Error: Missing dependency: magick\n" >&2
    exit 1
fi

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <image>\n" "$(basename "$0")" >&2
    exit 1
fi

# 图像路径
IMG_PATH="$1"

if [[ ! -f "$IMG_PATH" ]]; then
    printf "Error: %s does not exist.\n" "$IMG_PATH" >&2
    exit 1
fi

# 定义输出路径
output_path="${IMG_PATH%.*}_crop11.png"

# --- 开始执行 ---

# 居中裁剪一个最大正方形
magick "$IMG_PATH" \
    -gravity Center \
    -crop '%[fx:min(w,h)]x%[fx:min(w,h)]+0+0' \
    +repage \
    "$output_path"

printf "OK -> %s\n" "$output_path"
