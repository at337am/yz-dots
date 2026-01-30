#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途：从视频提取帧为图片, 默认 JPG, 可以指定为 PNG
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

set -euo pipefail

# 定义颜色
RED='\033[0;31m'        # 红色
GREEN='\033[0;32m'      # 绿色
NC='\033[0m'            # 重置色

# 默认变量
VID_PATH=""
ext="jpg"
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
            ext="png"
            ffmpeg_opts=(-compression_level 0)
            shift
            ;;
        -*)
            printf "${RED}Error:${NC} Unknown flag %s\n" "$1" >&2
            usage >&2
            exit 1
            ;;
        *)
            # 如果不是选项，且 VID_PATH 为空，则认为是视频文件
            if [[ -z "$VID_PATH" ]]; then
                VID_PATH="$1"
                shift
            else
                printf "${RED}Error:${NC} 仅支持单个视频文件\n" >&2
                usage >&2
                exit 1
            fi
            ;;
    esac
done

# 验证输入
if [[ -z "$VID_PATH" ]]; then
    printf "${RED}Error:${NC} No files specified.\n" >&2
    usage >&2
    exit 1
fi

if [[ ! -f "$VID_PATH" ]]; then
    printf "${RED}Error:${NC} %s does not exist.\n" "$VID_PATH" >&2
    exit 1
fi

# 创建输出目录
output_dir="${VID_PATH%.*}_frames"
mkdir -p "$output_dir"

printf "Output directory created: ${GREEN}%s${NC}\n" "$output_dir"

output_path="$output_dir/frame_%04d.$ext"
printf "Extraction frame format: ${GREEN}%s${NC}\n" "$ext"

ffmpeg -hide_banner -loglevel error -stats \
    -i "$VID_PATH" \
    -vsync 0 \
    "${ffmpeg_opts[@]}" \
    "$output_path"

printf "Done.\n"
