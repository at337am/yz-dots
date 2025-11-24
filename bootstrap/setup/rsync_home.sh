#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "rsync" &> /dev/null; then
    printf "Error: Missing dependency: rsync\n" >&2
    exit 1
fi

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

# 执行同步
rsync -a "$DOTS_PATH/" ~/

# 解压 p10k 主题
rm -rf ~/.lain/themes/powerlevel10k
tar -zxf ~/.lain/themes/powerlevel10k.tar.gz -C ~/.lain/themes
rm -rf ~/.lain/themes/powerlevel10k.tar.gz
