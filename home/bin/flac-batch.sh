#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途：
# 该脚本用于批量处理指定目录下的 FLAC 音频文件。
# 功能包括：
# 1. 自动解压目录中的 ZIP 压缩包。
# 2. 将对应的封面图片（JPG）调整尺寸并嵌入到 FLAC 文件中。
# 3. 将对应的歌词文件（LRC）写入 FLAC 元数据。
# 处理完成的文件会统一输出到 flac_batch_result 目录。
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

dependencies=("ffmpeg" "magick" "fd" "unzip")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: 缺少依赖命令: %s\n" "$cmd" >&2
        exit 1
    fi
done

if [[ "$#" -ne 1 ]]; then
    printf "参数错误\n" >&2
    printf "用法: %s <目录路径>\n" "flac_batch.sh" >&2
    exit 1
fi

TARGET_DIR="$1"

if [[ ! -d "$TARGET_DIR" ]]; then
    printf "Error: 目录不存在: %s\n" "$TARGET_DIR" >&2
    exit 1
fi

tmp_dir=$(mktemp -d)
trap 'command rm -rf "$tmp_dir"' EXIT

fd -HIi -e zip . "$TARGET_DIR" -x unzip {} -d "$tmp_dir/{/.}"

printf "目录解压完毕\n"

merge_flac_metadata() {
    local audio_file="$1"
    local cover_file="$2"
    local lyrics_file="$3"
    local output_file="$4"
    local temp_cover_file

    # 创建一个临时文件名
    # 使用 trap 确保脚本退出时临时文件被删除
    temp_cover_file=$(mktemp --suffix=.jpg)
    trap 'command rm -f "$temp_cover_file"' RETURN

    magick "$cover_file" -resize 1440x -quality 92 "$temp_cover_file"

    ffmpeg -hide_banner -loglevel error \
        -i "$audio_file" \
        -i "$temp_cover_file" \
        -map 0:a \
        -map 1:v \
        -c copy \
        -disposition:v attached_pic \
        -metadata "LYRICS=$(cat "$lyrics_file")" \
        -y "$output_file"

    printf "已处理 -> %s\n" "$output_file"
}

# 导出函数, 使其对子进程可见
export -f merge_flac_metadata

mkdir -p flac_batch_result

if fd -HIi -e flac . "$tmp_dir" -x \
    bash -c 'merge_flac_metadata "{}" "{.}.jpg" "{.}.lrc" "flac_batch_result/{/.}.flac"'
then
    printf "所有 flac 都已处理完成\n"
else
    printf "Error: 处理 flac 文件时发生错误\n" >&2
    exit 1
fi
