#!/usr/bin/env bash

set -euo pipefail

if ! command -v "rsync" &> /dev/null; then
    printf "Error: Missing dependency: rsync\n" >&2
    exit 1
fi

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

# 执行同步
rsync -a "$DOTS_PATH/" ~/

# 解压 p10k 主题
rm -rf ~/.lain/themes
tar -zxf ~/.lain/themes/powerlevel10k.tar.gz -C ~/.lain/themes
rm -rf ~/.lain/themes/powerlevel10k.tar.gz

# 设置相关文件权限
chmod 600 ~/.zshrc
chmod 600 ~/.zprofile
chmod 600 ~/.p10k.zsh

chmod 600 ~/.gitconfig

chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
