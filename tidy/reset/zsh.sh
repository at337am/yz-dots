#!/usr/bin/env bash

# 这个脚本会重置 zsh

set -euo pipefail

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to reset zsh?"; then
    printf "Operation cancelled.\n" >&2
    exit 1
fi

DOTS_PATH="/workspace/dev/yz-dots/home"

# 删除缓存
rm -rf ~/.zsh_history
rm -rf ~/.zcompdump
rm -rf ~/.cache/p10k*

# 删除配置
rm -rf ~/.lain
rm -rf ~/.p10k.zsh
rm -rf ~/.zprofile
rm -rf ~/.zshrc

# 同步 zsh 配置
rsync -a \
    "$DOTS_PATH/.lain" \
    "$DOTS_PATH/.p10k.zsh" \
    "$DOTS_PATH/.zprofile" \
    "$DOTS_PATH/.zshrc" \
    ~/

# 解压 p10k 主题
/workspace/dev/yz-dots/bootstrap/tasks/extract_p10k_theme.sh

# 软链接配置
/workspace/dev/yz-dots/bootstrap/tasks/symlink_dotfiles.sh zsh

# 设置路径权限
/workspace/dev/yz-dots/bootstrap/tasks/set_path_perms.sh zsh

printf "Done.\n"
