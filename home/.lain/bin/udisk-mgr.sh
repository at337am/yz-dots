#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "udisksctl" &> /dev/null; then
    printf "Error: Missing dependency: udisksctl\n" >&2
    exit 1
fi

# 配置变量
TARGET_DEV="/dev/sda"
TARGET_PART="${TARGET_DEV}1"

# 发送通知
notify() {
    notify-send -a "udisk" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

# 判断是否为块设备
if [[ ! -b "$TARGET_DEV" ]]; then
    notify-send -u critical "错误" "未找到设备 $TARGET_DEV"
    exit 1
fi

# 定义挂载函数
do_mount() {
    if mountpoint -q "/run/media/$USER/"*; then
        notify-send "提示" "设备似乎已经挂载。"
        exit 0
    fi

    # 使用 udisksctl 挂载
    OUTPUT=$(udisksctl mount -b "$TARGET_PART" 2>&1)
    if [ $? -eq 0 ]; then
        MOUNT_PATH=$(echo "$OUTPUT" | grep -oP "at \K.*")
        notify-send "U盘已挂载" "路径: $MOUNT_PATH"
    else
        notify-send -u critical "挂载失败" "$OUTPUT"
    fi
}

# 定义卸载并断电函数
do_unmount() {
    # 1. 卸载分区
    if udisksctl unmount -b "$TARGET_PART" 2>/dev/null; then
        # 2. 安全断电 (Power off)
        if udisksctl power-off -b "$TARGET_DEV" 2>/dev/null; then
            notify-send "U盘安全移除" "数据已同步，电源已切断，可以拔出了。"
        else
            notify-send "卸载成功" "分区已卸载，但断电失败。"
        fi
    else
        notify-send -u critical "卸载失败" "请检查是否有程序正在使用 U 盘文件。"
    fi
}

# 脚本逻辑选择
case "$1" in
    -m|--mount)
        do_mount
        ;;
    -u|--unmount)
        do_unmount
        ;;
    *)
        echo "用法: $0 {-m|--mount | -u|--unmount}"
        echo "示例: $0 -m (挂载并通知)"
        echo "示例: $0 -u (卸载、断电并通知)"
        ;;
esac