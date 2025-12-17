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
TARGET_DEV="/dev/sda"
TARGET_PART="${TARGET_DEV}1"

# 判断 U 盘是否已插入
check_dev() {
    if [[ ! -b "$TARGET_DEV" ]]; then
        printf "未找到块设备 %s\n" "$TARGET_DEV" >&2
        exit 1
    fi
}

# 帮助信息
usage() {
    printf "Usage:\n"
    printf "  %s [flags]\n" "$(basename "$0")"
    printf "\nFlags:\n"
    printf "  -m, --mount           挂载 U 盘\n"
    printf "  -u, --unmount         安全弹出 U 盘 (卸载并断电)\n"
    printf "  -h, --help            Show this help message\n"
}

# 挂载函数
do_mount() {
    if findmnt -n "$TARGET_PART" &> /dev/null; then
        MOUNT_PATH=$(findmnt -n -o TARGET "$TARGET_PART")
        printf "设备已挂载到: %s\n" "$MOUNT_PATH"
        exit 0
    fi

    udisksctl mount -b "$TARGET_PART"
}

# 卸载函数
do_unmount() {
    udisksctl unmount -b "$TARGET_PART"
    udisksctl power-off -b "$TARGET_DEV"
}

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    usage >&2
    exit 1
fi

# 脚本逻辑选择
case "$1" in
    -m|--mount)
        check_dev
        do_mount
        ;;
    -u|--unmount)
        check_dev
        do_unmount
        do_power_off
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
