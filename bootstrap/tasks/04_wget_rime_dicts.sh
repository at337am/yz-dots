#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if [[ -d "$HOME/.local/share/fcitx5/rime/en_dicts" ]]; then
    echo "Script will not run again, skipping."
    return 0
fi

echo "Starting download of Rime input dictionary..."

wget -O ~/.local/share/fcitx5/rime/all_dicts.zip \
    https://github.com/iDvel/rime-ice/releases/latest/download/all_dicts.zip && \
unzip ~/.local/share/fcitx5/rime/all_dicts.zip -d ~/.local/share/fcitx5/rime/

echo "Rime dictionary download complete."

echo "Cleaning up temporary files..."

command rm -rfv ~/.local/share/fcitx5/rime/all_dicts.zip

echo "Temporary file cleanup complete."
