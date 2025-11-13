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

if ! confirm "Are you sure you want to reset fcitx5?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

# ----------

pkill -9 fcitx5 || true

sleep 1.5

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

# ----------
rsync -a --delete \
        "$DOTS_PATH/.local/share/fcitx5/" \
        ~/.local/share/fcitx5/

# 拉取 rime-ice 词库
source ~/workspace/dev/yz-dots/bootstrap/tasks/04_wget_rime_dicts.sh

# ----------

command rm -rf ~/.local/share/fcitx5/rime/custom_phrase.txt
command rm -rf ~/.local/share/fcitx5/rime/default.yaml
command rm -rf ~/.local/share/fcitx5/rime/yz_pinyin.schema.yaml
command rm -rf ~/.local/share/fcitx5/rime/yz_pinyin.dict.yaml
command rm -rf ~/.local/share/fcitx5/themes
command rm -rf ~/.config/fcitx5

ln -s "$DOTS_PATH/.local/share/fcitx5/rime/custom_phrase.txt" ~/.local/share/fcitx5/rime/custom_phrase.txt
ln -s "$DOTS_PATH/.local/share/fcitx5/rime/default.yaml" ~/.local/share/fcitx5/rime/default.yaml
ln -s "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.schema.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.schema.yaml
ln -s "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.dict.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.dict.yaml
ln -s "$DOTS_PATH/.local/share/fcitx5/themes" ~/.local/share/fcitx5/themes
ln -s "$DOTS_PATH/.config/fcitx5" ~/.config/fcitx5

printf "Done.\n"
