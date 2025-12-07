#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "magick" &> /dev/null; then
    printf "Error: Missing dependency: magick\n" >&2
    exit 1
fi

if [[ "$#" -ne 2 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <image> <text>\n" "$(basename "$0")" >&2
    exit 1
fi

# 图像路径
IMG_PATH="$1"

if [[ ! -f "$IMG_PATH" ]]; then
    printf "Error: %s does not exist.\n" "$IMG_PATH" >&2
    exit 1
fi

# 文字内容
CAPTION_TEXT="$2"

# 获取图片的高度
image_height=$(magick identify -format "%h" "$IMG_PATH")

# --- 定义参数 ---

# 字体颜色
font_color="white"

# 字体样式
# Josefin-Sans-Regular
# Josefin-Sans-Italic
# Google-Sans-Code-Regular
# Google-Sans-Code-Italic
# Zhi-Mang-Xing-Regular
font_style="Zhi-Mang-Xing-Regular"

# 文字位置
# Center    居中
# North     中上方
# South     中下方
# NorthWest 左上角
# NorthEast 右上角
# SouthWest 左下角
# SouthEast 右下角
position="SouthEast"

# 定义文字高度占图片总高度的百分比
# percentage=0.03
percentage=0.06

# 字体大小
font_size=$(echo "$image_height * $percentage / 1" | bc)

# 底部边距
x_offset=$(echo "$font_size * 0.5 / 1" | bc)
y_offset=$(echo "$font_size * 0.5 / 1" | bc)

# x_offset=0
# y_offset=$(echo "$font_size * 1 / 1" | bc)

# 定义输出路径
dirname=$(dirname "$IMG_PATH")
filename=$(basename "${IMG_PATH%.*}")
output_path="${dirname}/${filename}_caption.png"

# --- 开始执行 ---

# 输出提示信息
printf "图片高度: %s px\n" "$image_height"
printf "字体大小: %s pt\n" "$font_size"
printf "水平偏移: %s px, 垂直偏移: %s px\n" "$x_offset" "$y_offset"

# 执行 magick 命令
magick "$IMG_PATH" \
    -gravity "$position" \
    -font "$font_style" \
    -pointsize "$font_size" \
    -fill "$font_color" \
    -annotate +"$x_offset"+"$y_offset" "$CAPTION_TEXT" \
    "$output_path"

printf "OK -> %s\n" "$output_path"
