#!/usr/bin/env bash

# 这个脚本会同步所有, 应当不会发生任何变化

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
    printf "Operation cancelled.\n" >&2
    exit 1
fi

# 同步所有配置
/workspace/dev/yz-dots/bootstrap/tasks/sync_dotfiles.sh
rm -rf ~/.lain/themes/powerlevel10k.tar.gz

# 软链接配置
/workspace/dev/yz-dots/bootstrap/tasks/symlink_dotfiles.sh

# 设置路径权限
/workspace/dev/yz-dots/bootstrap/tasks/set_path_perms.sh

printf "Done.\n"
