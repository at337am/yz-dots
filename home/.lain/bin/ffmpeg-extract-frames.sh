#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途：从视频提取帧为图片
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

set -euo pipefail

# 定义颜色
RED='\033[31m'
GREEN='\033[32m'
NC='\033[0m'

# 默认变量
VIDEO_FILE=""
target_ext="jpg"
ffmpeg_opts=(-q:v 6)

# 依赖检查
if ! command -v "ffmpeg" &> /dev/null; then
    printf "Error: Missing dependency: ffmpeg\n" >&2
    exit 1
fi

usage() {
    printf "Usage:\n"
    printf "  %s <video> [flags]\n" "$(basename "$0")"
    printf "\nFlags:\n"
    printf "  -p, --png     使用 PNG 格式输出 (默认: JPG)\n"
    printf "  -h, --help    显示帮助信息\n"
}

# 主程序入口
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -p|--png)
            target_ext="png"
            ffmpeg_opts=(-compression_level 0)
            shift
            ;;
        -*)
            printf "${RED}Error: Unknown flag %s${NC}\n" "$1" >&2
            usage >&2
            exit 1
            ;;
        *)
            # 如果不是选项，且 VIDEO_FILE 为空，则认为是视频文件
            if [[ -z "$VIDEO_FILE" ]]; then
                VIDEO_FILE="$1"
                shift
            else
                printf "${RED}Error: 仅支持单个视频文件${NC}\n" >&2
                exit 1
            fi
            ;;
    esac
done

# 验证输入
if [[ -z "$VIDEO_FILE" ]]; then
    printf "${RED}Error: No files specified.${NC}\n" >&2
    usage >&2
    exit 1
fi

if [[ ! -f "$VIDEO_FILE" ]]; then
    printf "${RED}Error: %s does not exist.${NC}\n" "$VIDEO_FILE" >&2
    exit 1
fi

video_base=$(basename "$VIDEO_FILE")
output_dir="${video_base%.*}_frames"

# 创建输出目录
mkdir -p "$output_dir"

output_path="$output_dir/output_%04d.$target_ext"

ffmpeg -hide_banner -loglevel error -stats \
    -i "$VIDEO_FILE" \
    -vsync 0 \
    "${ffmpeg_opts[@]}" \
    "$output_path"

printf "Done.\n"
