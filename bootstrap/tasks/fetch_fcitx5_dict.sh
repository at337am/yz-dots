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

destination_path="$HOME/.local/share/fcitx5/rime"

if [[ ! -d "$destination_path" ]]; then
    printf "Error: %s does not exist.\n" "$destination_path" >&2
    exit 1
fi

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# 拉取 rime-ice 词库到缓存路径
wget -O "$tmp_dir/all_dicts.zip" \
    https://github.com/iDvel/rime-ice/releases/latest/download/all_dicts.zip

# 静默解压
unzip -q "$tmp_dir/all_dicts.zip" -d "$tmp_dir/all_dicts"

# 移动词库到指定位置
mv "$tmp_dir/all_dicts/cn_dicts" "$destination_path"
