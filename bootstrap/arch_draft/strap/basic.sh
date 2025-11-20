#!/usr/bin/env bash

set -euo pipefail

# 安装完软件包后执行此脚本

# todo 这里开头要检查每个命令的依赖


go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct

# 启动服务:
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# 关闭文件管理器的 "最近打开"
gsettings set org.gnome.desktop.privacy remember-recent-files false

rm -f ~/.local/share/recently-used.xbel
