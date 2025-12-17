#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途：从视频提取帧为图片 (Arch Linux / Hyprland 风格重构版)
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

set -euo pipefail

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# 默认变量
TARGET_EXT="jpg"
VIDEO_FILE=""

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

# 检查文件是否存在
check_file() {
    local video_path="$1"
    if [[ ! -f "$video_path" ]]; then
        printf "${RED}Error: %s does not exist.${NC}\n" "$video_path" >&2
        exit 1
    fi
}

# 核心逻辑函数
extract_frames() {
    local video_path="$1"
    local ext="$2"

    local video_base
    video_base=$(basename "$video_path")

    local output_dir
    local ffmpeg_opts=()
    local output_name

    # 根据格式配置参数
    if [[ "$ext" == "jpg" ]]; then
        output_dir="${video_base%.*}_jpg_frames"
        ffmpeg_opts=(-q:v 6)
    elif [[ "$ext" == "png" ]]; then
        output_dir="${video_base%.*}_png_frames"
        ffmpeg_opts=(-compression_level 0)
    else
        printf "${RED}Error: 不支持的格式: %s${NC}\n" "$ext" >&2
        exit 1
    fi

    # 创建目录
    if [[ ! -d "$output_dir" ]]; then
        mkdir -p "$output_dir"
    fi

    # todo 这里似乎只支持 四位数字? 如果 超过四位呢? 
    output_name="$output_dir/output_%04d.$ext"

    printf "${BLUE}:: 正在处理: %s -> %s (%s)${NC}\n" "$video_base" "$output_dir" "$ext"

    ffmpeg -i "$video_path" \
        -vsync 0 \
        "${ffmpeg_opts[@]}" \
        "$output_name"

    printf "\n${GREEN}:: 完成! 已提取至 -> %s${NC}\n" "$output_dir"
}

# 主程序入口
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -p|--png)
            TARGET_EXT="png"
            shift
            ;;
        -*)
            printf "${RED}Error: Unknown option %s${NC}\n" "$1" >&2
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

# 检查文件
check_file "$VIDEO_FILE"

# 调用主函数
extract_frames "$VIDEO_FILE" "$TARGET_EXT"
