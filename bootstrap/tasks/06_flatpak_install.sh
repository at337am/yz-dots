#!/usr/bin/env bash

set -e

flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak --user install -y flathub \
    md.obsidian.Obsidian \
    org.localsend.localsend_app \
    io.mgba.mGBA \
    io.github.ungoogled_software.ungoogled_chromium \
    org.telegram.desktop

echo "Flatpak app installation complete."
