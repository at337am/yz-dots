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

if ! confirm "Are you sure you want to reset fcitx5?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

# ----------

pkill -9 fcitx5 || true

sleep 1

# 同步配置
rsync -a --delete \
        "/workspace/dev/yz-dots/home/.local/share/fcitx5/" \
        ~/.local/share/fcitx5/

# 拉取词库 (rime-ice) 到 fcitx5
/workspace/dev/yz-dots/bootstrap/setup/fetch_fcitx5_dict.sh

/workspace/dev/yz-dots/bootstrap/setup/configure_symlinks.sh fcitx5

printf "Done.\n"
