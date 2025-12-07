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
dirname=$(dirname "$IMG_PATH")
filename=$(basename "${IMG_PATH%.*}")
output_path="${dirname}/${filename}_crop34.png"

# --- 开始执行 ---

# 将原图从中心裁剪为 3:4 的宽高比，高度保持原图高度，宽度按比例计算
magick "$IMG_PATH" \
    -gravity Center \
    -crop '%[fx:h*3/4]x%[h]+0+0' \
    +repage \
    "$output_path"

printf "OK -> %s\n" "$output_path"
