#!/usr/bin/env bash

set -euo pipefail

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to reset Rime?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

rsync -a --delete \
        "$DOTS_PATH"/.local/share/fcitx5/ \
        ~/.local/share/fcitx5/

# 从 GitHub 仓库 拉取词库
wget -O ~/.local/share/fcitx5/rime/all_dicts.zip \
    https://github.com/iDvel/rime-ice/releases/latest/download/all_dicts.zip && \
unzip ~/.local/share/fcitx5/rime/all_dicts.zip -d ~/.local/share/fcitx5/rime/

# 删除冗余文件
command rm -rf ~/.local/share/fcitx5/rime/all_dicts.zip
command rm -rf ~/.local/share/fcitx5/rime/weasel.yaml

# 软链接 自定义输入习惯
command rm -rf ~/.local/share/fcitx5/rime/custom_phrase.txt && \
ln -s "$DOTS_PATH/.local/share/fcitx5/rime/custom_phrase.txt" ~/.local/share/fcitx5/rime/custom_phrase.txt

# 软链接 配置
command rm -rf ~/.config/fcitx5
ln -s "$DOTS_PATH/.config/fcitx5" ~/.config/fcitx5

printf "Done.\n"
