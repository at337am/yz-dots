#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=- 
# 脚本用途:
# 在当前目录中批量扫描视频文件 (mp4, mkv, mov)
# 截取每个视频第 2 秒的帧图像作为缩略图
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=- 

set -euo pipefail

# 依赖检查
if ! command -v "ffmpeg" &> /dev/null; then
    printf "Error: Missing dependency: ffmpeg\n" >&2
    exit 1
fi

# nullglob 选项表示如果通配符没有匹配到任何文件, 则扩展为空字符串数组
shopt -s nullglob
video_files=(*.mp4 *.mkv *.mov)
shopt -u nullglob

if [[ ${#video_files[@]} -eq 0 ]]; then
    printf "Error: No video files (mp4, mkv, mov) found in current directory.\n" >&2
    exit 0
fi

output_dir="thumbnails"
mkdir -p "$output_dir"

printf "Found %d video(s). Processing...\n" "${#video_files[@]}"

for f in "${video_files[@]}"; do

    base_name=$(basename "$f")

    ffmpeg -hide_banner -loglevel error \
        -ss 00:00:02 \
        -i "$f" \
        -vframes 1 \
        -pix_fmt yuvj420p \
        -q:v 2 \
        -y "$output_dir/${base_name%.*}_thumb.jpg"

    printf "ok -> %s\n" "$f"
done

printf "Done.\n"

# todo:
# feat 支持处理单个文件
