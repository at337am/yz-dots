#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
dependencies=("wget" "unzip")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

# 拉取 rime-ice 词库
wget -O /tmp/all_dicts.zip \
    https://github.com/iDvel/rime-ice/releases/latest/download/all_dicts.zip

unzip /tmp/all_dicts.zip -d /tmp/all_dicts

cp -a /tmp/all_dicts/cn_dicts ~/.local/share/fcitx5/rime

rm -rf /tmp/all_dicts.zip
rm -rf /tmp/all_dicts
