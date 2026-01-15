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
