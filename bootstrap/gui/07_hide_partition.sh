#!/usr/bin/env bash

# 隐藏另一个分区的卷挂载

set -euo pipefail

if [[ -z "$1" ]]; then
    printf "Error: No UUID provided.\n" >&2
    exit 1
fi

HIDE_UUID="$1"

files="/etc/udev/rules.d/99-hide-partition.rules"

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
