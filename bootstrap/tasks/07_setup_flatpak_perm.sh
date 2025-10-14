#!/usr/bin/env bash

set -euo pipefail

# 1. 撤销权限

# 或者直接去这里删除:
# command rm -rfv ~/.local/share/flatpak/overrides

flatpak --user override --reset md.obsidian.Obsidian
flatpak --user override --reset org.localsend.localsend_app
flatpak --user override --reset io.github.ungoogled_software.ungoogled_chromium
flatpak --user override --reset org.telegram.desktop
flatpak --user override --reset io.mgba.mGBA

# 2. 设置权限
flatpak --user override md.obsidian.Obsidian --env=GTK_IM_MODULE=fcitx

flatpak --user override org.localsend.localsend_app \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem="$HOME/workspace" \
    --filesystem=/workspace \
    --filesystem=/data

flatpak --user override io.github.ungoogled_software.ungoogled_chromium \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem="$HOME/workspace" \
    --filesystem=/workspace \
    --filesystem=/data

flatpak --user override org.telegram.desktop \
    --filesystem=xdg-download \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem="$HOME/workspace" \
    --filesystem=/workspace \
    --filesystem=/data

flatpak --user override io.mgba.mGBA \
    --filesystem=/data

echo "Flatpak app permissions have been set."
