#!/usr/bin/env bash

set -e

echo "Setting up Flathub repository..."

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Starting installation..."

flatpak install --user -y flathub \
    md.obsidian.Obsidian \
    org.localsend.localsend_app \
    io.mgba.mGBA \
    io.github.ungoogled_software.ungoogled_chromium \
    org.telegram.desktop

exit 0
