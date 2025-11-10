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

if ! confirm "Are you sure you want to reset Zsh?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

# 先删除冗余文件
command rm -rf ~/.zsh_history
command rm -rf ~/.zcompdump
command rm -rf ~/.cache/p10k*

rsync -a \
        "$DOTS_PATH/.lain" \
        "$DOTS_PATH/.p10k.zsh" \
        "$DOTS_PATH/.zshrc" \
        "$DOTS_PATH/.zprofile" \
        ~/

# 解压 p10k 主题
tar -zxf ~/.lain/themes/powerlevel10k.tar.gz -C ~/.lain/themes
command rm -rf ~/.lain/themes/powerlevel10k.tar.gz

# 软链接 alias
command rm -rf ~/.lain/lib/aliases.zsh
ln -s "$DOTS_PATH/.lain/lib/aliases.zsh" ~/.lain/lib/aliases.zsh

# 设置权限
chmod 600 ~/.zshrc
chmod 600 ~/.zprofile
chmod 600 ~/.p10k.zsh

printf "Done.\n"
