#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if [[ -d "$HOME/.lain/themes/powerlevel10k" ]]; then
    echo "此脚本不再重复执行, 跳过"
    exit 0
fi

command rm -rf ~/.p10k.zsh
command rm -rf ~/.zshrc
command rm -rf ~/.zsh_history
command rm -rf ~/.zcompdump
command rm -rf ~/.zprofile
command rm -rf ~/.lain
command rm -rf ~/.cache/p10k*

# -------------------------------- #
echo "开始同步所有配置..."

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

SOURCE_PATH="$SCRIPT_DIR/../../home/"

# --- 检查源目录是否存在 ---
if [[ ! -d "$SOURCE_PATH" ]]; then
    echo "Error: 计算出的源目录不存在！"
    echo "路径: $SOURCE_PATH"
    exit 1
fi

echo "源配置目录: $SOURCE_PATH"

rsync -a "$SOURCE_PATH" ~/

echo "所有配置同步完成"
# -------------------------------- #



# -------------------------------- #
echo "设置 zsh 文件权限..."
chmod 600 ~/.zshrc
chmod 600 ~/.zprofile
chmod 600 ~/.p10k.zsh

echo "设置 gitconfig 文件权限..."
chmod 600 ~/.gitconfig

echo "设置 ssh 文件权限..."
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

echo "文件权限都已设置完成"
# -------------------------------- #



# -------------------------------- #
echo "解压 p10k 主题到 ~/.lain/themes..."

tar -zxf ~/.lain/themes/powerlevel10k.tar.gz -C ~/.lain/themes

echo "p10k 主题解压完成"
# -------------------------------- #



# -------------------------------- #
echo "刷新 font 字体缓存..."

fc-cache -f

echo "字体缓存已刷新"
# -------------------------------- #



# -------------------------------- #
echo "清理多余文件..."

command rm -rfv ~/.lain/themes/powerlevel10k.tar.gz
command rm -rfv ~/.local/share/fcitx5/rime/weasel.yaml

echo "多余文件清理完成"
# -------------------------------- #
