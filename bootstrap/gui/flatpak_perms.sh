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

flatpak override --user --reset

flatpak override --user --reset md.obsidian.Obsidian
flatpak override --user --reset org.localsend.localsend_app
flatpak override --user --reset io.github.ungoogled_software.ungoogled_chromium
flatpak override --user --reset org.telegram.desktop



# ------------ 全局权限 ------------

flatpak override --user --filesystem=xdg-config/gtk-3.0
flatpak override --user --filesystem=xdg-config/gtk-4.0
# flatpak override --user --filesystem=xdg-config/qt5ct
# flatpak override --user --filesystem=xdg-config/qt6ct
flatpak override --user --socket=wayland



# ------------ App 权限 ------------

flatpak override --user org.localsend.localsend_app \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem="$HOME/workspace" \
    --filesystem=/workspace \
    --filesystem=/data

flatpak override --user io.github.ungoogled_software.ungoogled_chromium \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem="$HOME/workspace" \
    --filesystem=/workspace \
    --filesystem=/data

flatpak override --user org.telegram.desktop \
    --filesystem=xdg-download \
    --filesystem=xdg-videos \
    --filesystem=xdg-pictures \
    --filesystem=xdg-documents \
    --filesystem="$HOME/workspace" \
    --filesystem=/workspace \
    --filesystem=/data



# bak:

# flatpak override --user --reset io.mgba.mGBA
# flatpak override --user io.mgba.mGBA --filesystem=/data

printf "Done.\n"
