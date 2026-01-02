#!/usr/bin/env bash

# 这个脚本会重置 fcitx5

set -euo pipefail

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to reset fcitx5?"; then
    printf "Operation cancelled.\n" >&2
    exit 1
fi

# ----------

# 这里不知道为什么终端会卡住, 所以延迟执行
sleep 0.2

pkill -9 fcitx5 || true

sleep 1

DOTS_PATH="/workspace/dev/yz-dots/home"

# 同步 fcitx5 配置
rsync -a --delete \
        "$DOTS_PATH/.local/share/fcitx5/" \
        ~/.local/share/fcitx5/

# 拉取词库
/workspace/dev/yz-dots/bootstrap/tasks/fetch_fcitx5_dict.sh

# 软链接配置
/workspace/dev/yz-dots/bootstrap/tasks/symlink_dotfiles.sh fcitx5

printf "Done.\n"
