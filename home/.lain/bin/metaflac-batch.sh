#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途: 批量处理指定目录下的 FLAC 音频文件
# 功能描述:
# 1. 解压目录中所有的 .zip 文件
# 2. 调整封面图片尺寸再嵌入
# 3. 嵌入歌词文件
# 4. 统一输出到 flac_batch_result 目录
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

set -euo pipefail

# 依赖检查
dependencies=("metaflac" "magick" "ffmpeg" "fd" "unzip")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <dir>\n" "$(basename "$0")" >&2
    exit 1
fi

TARGET_DIR="$1"

if [[ ! -d "$TARGET_DIR" ]]; then
    printf "Error: %s does not exist.\n" "$TARGET_DIR" >&2
    exit 1
fi

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

fd -HIi -e zip . "$TARGET_DIR" -x unzip -q {} -d "$tmp_dir/{/.}"

printf "flac 源文件解压完毕, 准备处理封面和歌词...\n"

merge_flac_metadata() {
    local audio_file="$1"
    local cover_file="$2"
    local lyrics_file="$3"
    local output_file="$4"
    local temp_cover_file

    # 创建一个临时文件名
    temp_cover_file=$(mktemp "$tmp_dir/cover.XXXXXX.jpg")

    magick "$cover_file" -resize 1440x -quality 92 "$temp_cover_file"

    if flac --totally-silent --test "$audio_file"; then
        # 默认情况下, metaflac 会尽量利用填充块 (padding), 以避免在元数据大小发生变化时重写整个文件
        # 使用 `--dont-use-padding` 选项可以告诉 metaflac 不使用填充块, 每次修改都会直接重写文件

        # 移除旧封面, 生成一个干净的目标文件, 这一步是唯一需要单独执行的主要操作
        metaflac --dont-use-padding --remove --block-type=PICTURE --output-name="$output_file" "$audio_file"

        # 在新创建的 output_file 上, 一次性地移除旧歌词, 导入新封面, 导入新歌词
        metaflac \
        --dont-use-padding \
        --remove-tag=LYRICS \
        --import-picture-from="$temp_cover_file" \
        --set-tag-from-file="LYRICS=$lyrics_file" \
        "$output_file"

        if [[ -f "$output_file" ]]; then
            printf "\033[32m[metaflac] OK -> %s\033[0m\n" "$output_file"
        else
            printf "\033[31m[metaflac] ERR -> %s\033[0m\n" "$output_file" >&2
            return 1
        fi
    else
        ffmpeg -hide_banner -loglevel error \
            -i "$audio_file" \
            -i "$temp_cover_file" \
            -map 0:a \
            -map 1:v \
            -c copy \
            -disposition:v attached_pic \
            -metadata "LYRICS=$(cat "$lyrics_file")" \
            -y "$output_file"

        if [[ -f "$output_file" ]]; then
            printf "\033[35m[ffmpeg] OK -> %s\033[0m\n" "$output_file"
        else
            printf "\033[31m[ffmpeg] ERR -> %s\033[0m\n" "$output_file" >&2
            return 1
        fi
    fi
}

# 导出函数和变量, 使 fd -x 的子进程可见
export -f merge_flac_metadata
export tmp_dir

mkdir -p flac_batch_result

if fd -HIi -e flac . "$tmp_dir" -x \
    bash -c 'merge_flac_metadata "{}" "{.}.jpg" "{.}.lrc" "flac_batch_result/{/.}.flac"'
then
    printf "Done.\n"
else
    printf "Error: 处理 flac 文件时发生错误\n" >&2
    exit 1
fi
