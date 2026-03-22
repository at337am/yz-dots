#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "flatpak" &> /dev/null; then
    printf "Error: Missing dependency: flatpak\n" >&2
    exit 1
fi

# 镜像: flatpak remote-modify --user flathub --url=https://mirrors.ustc.edu.cn/flathub

add_flathub() {
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# install_app() {
#     flatpak install --user -y flathub \
#         io.github.efogdev.mpris-timer
# }

set_perms() {
    # 先重置权限, 或者直接删除文件: ~/.local/share/flatpak/overrides
    flatpak override --user --reset

    # 授权 GTK config 路径访问权限
    flatpak override --user --filesystem=xdg-config/gtk-3.0
    flatpak override --user --filesystem=xdg-config/gtk-4.0
    flatpak override --user --socket=wayland
    # flatpak override --user --filesystem=xdg-config/qt5ct
    # flatpak override --user --filesystem=xdg-config/qt6ct
}

add_flathub
# install_app
set_perms

printf "Done.\n"
