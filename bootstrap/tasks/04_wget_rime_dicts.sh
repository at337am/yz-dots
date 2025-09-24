#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if [[ -d "$HOME/.local/share/fcitx5/rime/en_dicts" ]]; then
    echo "此脚本不再重复执行, 跳过"
    exit 0
fi

# proxy_run() {
#     http_proxy=$http_proxy https_proxy=$https_proxy "$@"
# }

echo "开始拉取 rime 输入法词库..."

wget -O ~/.local/share/fcitx5/rime/all_dicts.zip \
    https://github.com/iDvel/rime-ice/releases/latest/download/all_dicts.zip && \
unzip ~/.local/share/fcitx5/rime/all_dicts.zip -d ~/.local/share/fcitx5/rime/

echo "rime 输入法词库拉取完成"

echo "清理临时文件..."

command rm -rfv ~/.local/share/fcitx5/rime/all_dicts.zip

echo "临时文件清理完成"
