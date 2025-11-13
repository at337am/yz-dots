#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if [[ -d "$HOME/.lain/themes/powerlevel10k" ]]; then
    echo "Skip: rsync_home.sh"
    return 0
fi

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
SOURCE_PATH="$SCRIPT_DIR/../../home"

# --- 检查源目录是否存在 ---
if [[ ! -d "$SOURCE_PATH" ]]; then
    echo "Error: Calculated source directory does not exist!"
    echo "Path: $SOURCE_PATH"
    return 1
fi

# 执行同步
rsync -a "$SOURCE_PATH/" ~/

# 后续处理
chmod 600 ~/.zshrc
chmod 600 ~/.zprofile
chmod 600 ~/.p10k.zsh

chmod 600 ~/.gitconfig

chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

tar -zxf ~/.lain/themes/powerlevel10k.tar.gz -C ~/.lain/themes
command rm -rf ~/.lain/themes/powerlevel10k.tar.gz

fc-cache -f

echo "All configurations synchronized."
