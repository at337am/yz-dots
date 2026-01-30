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
output_path="${IMG_PATH%.*}_pad23.png"

# --- 开始执行 ---

# 0.85 或 0.88
magick "$IMG_PATH" \
    -background white \
    -gravity center \
    -extent "%[fx:w/0.85]x%[fx:(w/0.85)*1.5]" \
    "$output_path"

printf "OK -> %s\n" "$output_path"
