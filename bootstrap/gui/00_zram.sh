#!/usr/bin/env bash

set -euo pipefail

sudo pacman -S --needed --noconfirm zram-generator

sudo rm -rf /etc/systemd/zram-generator.conf

# compression-algorithm = zstd  -> 使用性能最好的 zstd 算法
# zram-size = min(ram / 2, 8192) -> 大小为内存一半, 但最大不超过 8GB
# 我这里直接设置 4GB 了, 为了数字好看点
# swap-priority = 100 -> 设置高优先级, 确保优先使用
sudo tee /etc/systemd/zram-generator.conf <<EOF
[zram0]
compression-algorithm = zstd
zram-size = 4096
swap-priority = 100
EOF

printf "Done.\n"
