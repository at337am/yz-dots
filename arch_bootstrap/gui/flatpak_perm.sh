#!/usr/bin/env bash

set -euo pipefail

# todo 好像 flatpak 命令语法不太标准? 看看别人的



# --------------------- 重置权限 ---------------------
# 或者直接去这里删除:
# command rm -rfv ~/.local/share/flatpak/overrides

# 全局
flatpak --user override --reset

# App
flatpak --user override --reset md.obsidian.Obsidian
flatpak --user override --reset org.localsend.localsend_app
flatpak --user override --reset io.github.ungoogled_software.ungoogled_chromium
flatpak --user override --reset org.telegram.desktop




# --------------------- 设置权限 ---------------------

# 全局
flatpak --user override --filesystem=xdg-config/gtk-3.0
flatpak --user override --filesystem=xdg-config/gtk-4.0

# App
# flatpak --user override md.obsidian.Obsidian --env=GTK_IM_MODULE=fcitx5
flatpak --user override md.obsidian.Obsidian --socket=wayland

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
# flatpak --user override io.mgba.mGBA \
#     --filesystem=/data

printf "Done.\n"
