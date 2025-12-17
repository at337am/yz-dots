#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
dependencies=("udisksctl" "notify-send")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

# 定义颜色
RED='\033[0;31m'        # 红色
GREEN='\033[0;32m'      # 绿色
NC='\033[0m'            # 重置色

# 配置变量
target_dev="/dev/sda"
target_part="/dev/sda1"

# 判断 U 盘是否已插入
check_dev() {
    if [[ ! -b "$target_dev" ]]; then
        printf "未找到块设备 %s\n" "$target_dev" >&2
        exit 1
    fi
}

usage() {
    printf "Usage:\n"
    printf "  %s [flags]\n" "$(basename "$0")"
    printf "\nFlags:\n"
    printf "  -m, --mount           挂载 U 盘\n"
    printf "  -u, --unmount         安全弹出 U 盘 (卸载并断电)\n"
    printf "  -h, --help            Show this help message\n"
}

# 挂载
do_mount() {
    if findmnt -n "$target_part" &> /dev/null; then
        mount_path=$(findmnt -n -o TARGET "$target_part")
        printf "U 盘 (%s) 已挂载至: %s\n" "$target_part" "$mount_path"
        exit 0
    fi

    udisksctl mount -b "$target_part"
}

# 卸载, 断电
do_unmount() {
    udisksctl unmount -b "$target_part"
    udisksctl power-off -b "$target_dev"
}

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    usage >&2
    exit 1
fi

# 主程序入口
case "$1" in
    -m|--mount)
        check_dev
        do_mount
        ;;
    -u|--unmount)
        check_dev
        do_unmount
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        printf "${RED}Error: Unknown flag %s${NC}\n" "$1" >&2
        usage >&2
        exit 1
        ;;
esac
