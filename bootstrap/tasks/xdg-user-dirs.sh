#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "xdg-user-dirs-update" &> /dev/null; then
    printf "Error: Missing dependency: xdg-user-dirs-update\n" >&2
    exit 1
fi

LC_ALL=C xdg-user-dirs-update --force

config_file="$HOME/.config/user-dirs.dirs"

if [[ ! -f "$config_file" ]]; then
    printf "Error: %s does not exist.\n" "$config_file" >&2
    exit 1
fi

sed -i \
    -e 's#XDG_DESKTOP_DIR="$HOME/Desktop"#XDG_DESKTOP_DIR="$HOME"#' \
    -e 's#XDG_TEMPLATES_DIR="$HOME/Templates"#XDG_TEMPLATES_DIR="$HOME"#' \
    -e 's#XDG_PUBLICSHARE_DIR="$HOME/Public"#XDG_PUBLICSHARE_DIR="$HOME"#' \
    "$config_file"

if [[ $? -ne 0 ]]; then
    printf "Error: File update failed.\n" >&2
    exit 1
fi

rm -rf ~/Desktop ~/Templates ~/Public
