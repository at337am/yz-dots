#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "uv" &> /dev/null; then
    printf "Error: Missing dependency: uv\n" >&2
    exit 1
fi

# 定义颜色
RED='\033[0;31m'        # 红色
NC='\033[0m'            # 重置色

# 项目目录
TARGET_DIR="/opt/soft/XHS-Downloader"

# 检查项目目录是否存在
if [[ ! -d "$TARGET_DIR" ]]; then
    printf "Error: %s does not exist.\n" "$TARGET_DIR" >&2
    exit 1
fi

# 进入项目目录
cd "$TARGET_DIR"

# ----------------------------------
# 函数: 打印帮助信息
# ----------------------------------
usage() {
    printf "Usage:\n"
    printf "  %s [flags]\n" "$(basename "$0")"
    printf "\nFlags:\n"
    printf "  -c, --clear           清除历史记录\n"
    printf "  -s, --start           启动程序 (默认)\n"
    printf "  -h, --help            Show this help message\n"
}

# 清除历史记录
clear_history() {
    rm -rfv \
        Volume/ExploreID.db \
        Volume/MappingData.db \
        Volume/Download/ExploreData.db \
        Volume/Temp
}

# 启动程序
start_app() {
    uv run python main.py
}

# 参数个数不能大于 1
if [[ "$#" -gt 1 ]]; then
    printf "${RED}Error:${NC} Too many arguments.\n" >&2
    usage >&2
    exit 1
fi

# 如果 $1 为空 (无参数)，则赋值为 --start
action="${1:---start}"

case "$action" in
    -c|--clear)
        clear_history
        ;;
    -s|--start)
        start_app
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        printf "${RED}Error:${NC} Unknown flag %s\n" "$action" >&2
        usage >&2
        exit 1
        ;;
esac

printf "Done.\n"
