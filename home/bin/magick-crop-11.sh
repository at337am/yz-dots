#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途：
# 该脚本用于将指定图像裁剪为居中的正方形（1:1）。
# 功能说明：
# 1. 自动计算图像宽高，裁剪出最大可能的正方形区域。
# 2. 裁剪区域居中，保持图像主要内容完整。
# 3. 使用 ImageMagick 的 magick 命令处理。
# 4. 输出文件命名为“原文件名_1x1.png”。
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

if ! command -v "magick" &> /dev/null; then
    printf "Error: 缺少依赖命令: magick\n" >&2
    exit 1
fi

if [[ "$#" -ne 1 ]]; then
    printf "参数错误\n" >&2
    printf "用法: %s <图像文件>\n" "magick-crop-11.sh" >&2
    exit 1
fi

# 图像路径
IMG_PATH="$1"

if [[ ! -f "$IMG_PATH" ]]; then
    printf "Error: 图像文件不存在: %s\n" "$IMG_PATH" >&2
    exit 1
fi

# 定义输出路径
dirname=$(dirname "$IMG_PATH")
filename=$(basename "${IMG_PATH%.*}")
output_path="${dirname}/${filename}_1x1.png"

# --- 开始执行 ---

# 居中裁剪一个最大正方形
magick "$IMG_PATH" \
    -gravity Center \
    -crop '%[fx:min(w,h)]x%[fx:min(w,h)]+0+0' \
    +repage \
    "$output_path"

# 最后输出完成信息
if [[ "$?" -eq 0 ]]; then
    printf "OK -> %s\n" "$output_path"
else
    printf "ERR -> %s\n" "$output_path" >&2
    exit 1
fi
