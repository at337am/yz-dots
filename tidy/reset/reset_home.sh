#!/usr/bin/env bash

set -euo pipefail

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to reset home?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

# rsync -avh --dry-run --itemize-changes --exclude='.lain/themes' "$DOTS_PATH/" ~/
rsync -a --exclude='.lain/themes' "$DOTS_PATH/" ~/

# 设置文件权限
source ~/workspace/dev/yz-dots/fedora_bootstrap/tasks/04_set_permissions.sh

# 重新软链接
source ~/workspace/dev/yz-dots/fedora_bootstrap/gui/03_symlinks.sh

printf "Done.\n"
