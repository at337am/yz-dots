#!/usr/bin/env bash

set -e

echo "设置 Flathub 仓库..."

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "开始安装..."

flatpak install --user -y flathub \
    md.obsidian.Obsidian \
    org.localsend.localsend_app \
    io.mgba.mGBA \
    io.github.ungoogled_software.ungoogled_chromium \
    org.telegram.desktop

exit 0
