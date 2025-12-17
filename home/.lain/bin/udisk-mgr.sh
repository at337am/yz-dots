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
usb_dev="/dev/sda"
usb_part="/dev/sda1"

# 检查设备是否存在
check_dev() {
    if [[ ! -b "$usb_dev" ]]; then
        printf "未找到块设备 %s\n" "$usb_dev" >&2
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

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}



# 挂载
do_mount() {
    if findmnt -n "$usb_part" &> /dev/null; then
        mount_path=$(findmnt -n -o TARGET "$usb_part")
        printf "U 盘 (%s) 已挂载至: %s\n" "$usb_part" "$mount_path"
        exit 1
    fi

    udisksctl mount -b "$usb_part"
}

# 卸载, 断电
do_unmount() {
    if ! findmnt -n "$usb_part" &> /dev/null; then
        printf "U 盘 (%s) 未被挂载\n" "$usb_part"
        exit 1
    fi

    if ! confirm "Are you sure you want to eject the USB drive?"; then
        printf "Operation cancelled. Exiting...\n"
        exit 1
    fi

    udisksctl unmount -b "$usb_part"
    udisksctl power-off -b "$usb_dev"
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
