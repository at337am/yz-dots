#!/usr/bin/env bash

# 找到要隐藏分区的 UUID:
# lsblk -p
# lsblk -pf

set -euo pipefail

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <UUID>\n" "$(basename "$0")" >&2
    exit 1
fi

HIDE_UUID="$1"

files="/etc/udev/rules.d/99-hide-partition.rules"

# 它会直接覆盖
sudo tee "$files" <<EOF
SUBSYSTEM=="block", ENV{ID_FS_UUID}=="$HIDE_UUID", ENV{UDISKS_IGNORE}="1"
EOF

printf "Hidden partition UUID: %s\n" "$HIDE_UUID"

# 重载 udev 规则
sudo udevadm control --reload-rules
sudo udevadm trigger

printf "Done.\n"

# 最后可以重启一下
