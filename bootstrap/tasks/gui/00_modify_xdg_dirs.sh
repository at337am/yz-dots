#!/usr/bin/env bash

set -euo pipefail

LC_ALL=C xdg-user-dirs-update --force

CONFIG_FILE="$HOME/.config/user-dirs.dirs"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: 配置文件 '$CONFIG_FILE' 不存在"
    exit 1
fi

sed -i \
    -e 's#XDG_DESKTOP_DIR="$HOME/Desktop"#XDG_DESKTOP_DIR="$HOME"#' \
    -e 's#XDG_TEMPLATES_DIR="$HOME/Templates"#XDG_TEMPLATES_DIR="$HOME"#' \
    -e 's#XDG_PUBLICSHARE_DIR="$HOME/Public"#XDG_PUBLICSHARE_DIR="$HOME"#' \
    "$CONFIG_FILE"

if [[ $? -eq 0 ]]; then
    echo "配置文件 '$CONFIG_FILE' 已成功更新"
    command rm -rfv ~/Desktop ~/Templates ~/Public
    exit 0
else
    echo "Error: 文件更新失败"
    exit 1
fi
