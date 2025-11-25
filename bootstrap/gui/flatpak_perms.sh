#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "flatpak" &> /dev/null; then
    printf "Error: Missing dependency: flatpak\n" >&2
    exit 1
fi

# todo 好像 flatpak 命令语法顺序不太标准? 看看别人的



# ------------ 重置所有权限 ------------
# 
# 或者直接去这里删除:
# command rm -rfv ~/.local/share/flatpak/overrides

flatpak --user override --reset

flatpak --user override --reset md.obsidian.Obsidian
flatpak --user override --reset org.localsend.localsend_app
flatpak --user override --reset io.github.ungoogled_software.ungoogled_chromium
flatpak --user override --reset org.telegram.desktop



# ------------ 全局权限 ------------

flatpak --user override --filesystem=xdg-config/gtk-3.0
flatpak --user override --filesystem=xdg-config/gtk-4.0
flatpak --user override --filesystem=xdg-config/qt5ct
flatpak --user override --filesystem=xdg-config/qt6ct
flatpak --user override --socket=wayland



# ------------ App 权限 ------------

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



# bak:

# flatpak --user override --reset io.mgba.mGBA
# flatpak --user override io.mgba.mGBA --filesystem=/data

printf "Done.\n"
