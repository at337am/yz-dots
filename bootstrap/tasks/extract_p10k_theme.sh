#!/usr/bin/env bash

set -euo pipefail

p10k_theme="$HOME/.lain/themes/powerlevel10k.tar.gz"

if [[ ! -f "$p10k_theme" ]]; then
    printf "Error: %s does not exist.\n" "$p10k_theme" >&2
    exit 1
fi

# 解压 p10k 主题
tar -zxf "$p10k_theme" -C ~/.lain/themes
rm -rf "$p10k_theme"
