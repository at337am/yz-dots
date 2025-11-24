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

TARGET="$HOME/.local/share/fcitx5/rime"

if [[ ! -d "$TARGET" ]]; then
    printf "Error: %s does not exist.\n" "$TARGET" >&2
    exit 1
fi

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# 拉取 rime-ice 词库
wget -O "$tmp_dir/all_dicts.zip" \
    https://github.com/iDvel/rime-ice/releases/latest/download/all_dicts.zip

unzip "$tmp_dir/all_dicts.zip" -d "$tmp_dir/all_dicts"

cp -a "$tmp_dir/all_dicts/cn_dicts" "$TARGET"
