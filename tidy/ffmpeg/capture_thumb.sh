#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=- 
# 脚本用途：
#    在当前目录中批量扫描视频文件（mp4、mkv、mov），
#    并从每个视频的第 9 秒自动截取一帧缩略图。
# 
# 功能说明：
#    1. 检查是否已安装 ffmpeg，若缺失则终止执行。
#    2. 自动收集当前目录下所有匹配的视频文件。
#    3. 若不存在任何视频文件，则提示并退出。
#    4. 为输出缩略图创建独立目录 thumbnails。
#    5. 依次处理每个视频文件：
#         - 定位至第 9 秒
#         - 截取单帧画面
#         - 输出为对应的 JPG 缩略图文件
#    6. 全部处理完成后输出完成提示信息。
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
        -ss 00:00:09 \
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
