#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "flatpak" &> /dev/null; then
    printf "Error: Missing dependency: flatpak\n" >&2
    exit 1
fi

add_flathub() {
    flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# 必需的 App
install_standard() {
    flatpak --user install -y flathub \
        md.obsidian.Obsidian \
        org.localsend.localsend_app \
        io.github.ungoogled_software.ungoogled_chromium \
        org.telegram.desktop
}

# 附加的 App
install_extra() {
    flatpak --user install -y flathub \
        io.github.efogdev.mpris-timer \
        com.discordapp.Discord
}

usage() {
    printf "Usage: %s [extra]\n" "$(basename "$0")" >&2
}

if [[ "$#" -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
    usage
    exit 0
fi

if [[ "$#" -eq 0 ]]; then
    add_flathub
    install_standard
elif [[ "$#" -eq 1 && "$1" == "extra" ]]; then
    add_flathub
    install_extra
else
    printf "Error: Invalid arguments.\n" >&2
    usage
    exit 1
fi

# 暂时不需要了的
# flatpak --user install -y flathub io.mgba.mGBA

printf "Done.\n"
