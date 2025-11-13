#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if [[ -f "$HOME/.local/share/fcitx5/rime/cn_dicts/base.dict.yaml" ]]; then
    echo "Skip: wget_rime_dicts.sh"
    return 0
fi

# 拉取 rime-ice 词库
wget -O /tmp/all_dicts.zip \
    https://github.com/iDvel/rime-ice/releases/latest/download/all_dicts.zip

unzip /tmp/all_dicts.zip -d /tmp/all_dicts

cp -a /tmp/all_dicts/cn_dicts ~/.local/share/fcitx5/rime

command rm -rf /tmp/all_dicts.zip
command rm -rf /tmp/all_dicts

echo "Rime dictionaries downloaded."
