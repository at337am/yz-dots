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

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

# ----------
rsync -a --delete \
        "$DOTS_PATH/.local/share/fcitx5/" \
        ~/.local/share/fcitx5/

# 拉取 rime-ice 词库
~/workspace/dev/yz-dots/bootstrap/setup/wget_dicts.sh

~/workspace/dev/yz-dots/bootstrap/setup/symlinks.sh fcitx5

printf "Done.\n"
