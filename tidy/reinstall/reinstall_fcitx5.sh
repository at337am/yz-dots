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

if ! confirm "Are you sure you want to reinstall fcitx5?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

pkill -9 fcitx5 || true

sleep 2

sudo dnf -y remove \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-rime

sleep 1

command rm -rf ~/.local/share/fcitx5
command rm -rf ~/.config/fcitx5
command rm -rf ~/.config/fcitx

printf "删除并清理完成，准备重新安装...\n"

sleep 1

sudo dnf -y install \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-rime \

printf "Done.\n"
