#!/usr/bin/env bash

set -euo pipefail

sudo pacman -S --needed --noconfirm zram-generator

sudo rm -rf /etc/systemd/zram-generator.conf

# compression-algorithm = zstd  -> 使用性能最好的 zstd 算法
# zram-size = min(ram / 2, 8192) -> 大小为内存一半，但最大不超过 8GB，对大内存机器友好
# swap-priority = 100 -> 设置高优先级，确保优先使用
sudo tee /etc/systemd/zram-generator.conf <<EOF
[zram0]
compression-algorithm = zstd
zram-size = min(ram / 2, 8192)
swap-priority = 100
EOF

printf "Done.\n"
