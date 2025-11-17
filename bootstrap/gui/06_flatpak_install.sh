#!/usr/bin/env bash

set -euo pipefail

flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 必须要下的:
flatpak --user install -y flathub \
    md.obsidian.Obsidian \
    org.localsend.localsend_app \
    io.github.ungoogled_software.ungoogled_chromium \
    org.telegram.desktop

# 可选择的:
flatpak --user install -y flathub \
    io.github.efogdev.mpris-timer

# 暂时不需要了的
# flatpak --user install -y flathub io.mgba.mGBA

printf "Done.\n"
