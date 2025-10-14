#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if [[ -d "$HOME/.lain/themes/powerlevel10k" ]]; then
    echo "Script will not run again, skipping."
    return 0
fi

# -------------------------------- #
echo "Starting synchronization of all configurations..."

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

SOURCE_PATH="$SCRIPT_DIR/../../home/"

# --- 检查源目录是否存在 ---
if [[ ! -d "$SOURCE_PATH" ]]; then
    echo "Error: Calculated source directory does not exist!"
    echo "Path: $SOURCE_PATH"
    return 1
fi

rsync -a "$SOURCE_PATH" ~/

echo "All configurations synchronized."
# -------------------------------- #



# -------------------------------- #
echo "Setting zsh file permissions..."
chmod 600 ~/.zshrc
chmod 600 ~/.zprofile
chmod 600 ~/.p10k.zsh

echo "Setting gitconfig file permissions..."
chmod 600 ~/.gitconfig

echo "Setting ssh file permissions..."
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

echo "All file permissions set."
# -------------------------------- #



# -------------------------------- #
echo "Unpacking p10k theme to ~/.lain/themes..."

tar -zxf ~/.lain/themes/powerlevel10k.tar.gz -C ~/.lain/themes

echo "p10k theme unpacked."
# -------------------------------- #



# -------------------------------- #
echo "Refreshing font cache..."

fc-cache -f

echo "Font cache refreshed."
# -------------------------------- #



# -------------------------------- #
echo "Cleaning up redundant files..."

command rm -rfv ~/.lain/themes/powerlevel10k.tar.gz
command rm -rfv ~/.local/share/fcitx5/rime/weasel.yaml

echo "Redundant file cleanup complete."
# -------------------------------- #
