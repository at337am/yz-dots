#!/usr/bin/env bash

# 隐藏另一个分区的卷挂载

set -euo pipefail

HIDE_UUID="$1"

files="/etc/udev/rules.d/99-hide-partition.rules"

# todo 这一步 根本运行不到里面啊直接退出了 改一下思路, 检查参数个数吧

if [[ -z "$HIDE_UUID" ]]; then
    printf "Error: No UUID provided.\n" >&2
    exit 1
fi

# 先找到要隐藏分区的 UUID
# lsblk
# lsblk -f

sudo tee "$files" <<EOF
SUBSYSTEM=="block", ENV{ID_FS_UUID}=="$HIDE_UUID", ENV{UDISKS_IGNORE}="1"
EOF

# 重载 udev 规则
sudo udevadm control --reload-rules
sudo udevadm trigger

printf "Done.\n"

# 最后重启一下
