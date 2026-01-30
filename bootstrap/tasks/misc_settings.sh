#!/usr/bin/env bash

# 一些杂项配置

set -euo pipefail

# 依赖检查
dependencies=("gsettings" "go")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct

# 启动服务:
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# 关闭文件管理器的 "最近打开"
gsettings set org.gnome.desktop.privacy remember-recent-files false
rm -f ~/.local/share/recently-used.xbel

# 刷新字体
fc-cache -f

# ----------- 配置 ZRAM -----------
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
