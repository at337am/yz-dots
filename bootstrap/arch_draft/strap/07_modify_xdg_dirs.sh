#!/usr/bin/env bash

set -euo pipefail

LC_ALL=C xdg-user-dirs-update --force

CONFIG_FILE="$HOME/.config/user-dirs.dirs"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file '$CONFIG_FILE' does not exist."
    return 1
fi

sed -i \
    -e 's#XDG_DESKTOP_DIR="$HOME/Desktop"#XDG_DESKTOP_DIR="$HOME"#' \
    -e 's#XDG_TEMPLATES_DIR="$HOME/Templates"#XDG_TEMPLATES_DIR="$HOME"#' \
    -e 's#XDG_PUBLICSHARE_DIR="$HOME/Public"#XDG_PUBLICSHARE_DIR="$HOME"#' \
    "$CONFIG_FILE"

if [[ $? -eq 0 ]]; then
    command rm -rf ~/Desktop ~/Templates ~/Public
    echo "Configuration file '$CONFIG_FILE' successfully updated."
    return 0
else
    echo "Error: File update failed."
    return 1
fi
