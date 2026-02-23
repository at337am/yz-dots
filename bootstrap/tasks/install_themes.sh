#!/usr/bin/env bash

# Yaru-Colors (GTK Theme): https://www.gnome-look.org/p/1299514
# Tela-icon-theme: https://www.gnome-look.org/p/1279924

set -euo pipefail

# 依赖检查
if ! command -v "git" &> /dev/null; then
    printf "Error: Missing dependency: git\n" >&2
    exit 1
fi

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

gtk_themes(){
    # 当前脚本所在的目录
    local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    tar -xf "$script_dir/static/gtk-themes.tar.xz" -C ~/.local/share/themes
}

icon_themes() {
    # 卸载: ./install.sh -u
    git clone --depth 1 https://github.com/vinceliuice/Tela-icon-theme.git "$tmp_dir/Tela-icon-theme"
    cd "$tmp_dir/Tela-icon-theme"
    ./install.sh grey -d ~/.local/share/icons
}

gtk_themes
icon_themes

# 最后设置主题
gtk_script="$HOME/.config/wm-scripts/auto/gsettings.sh"

if [[ ! -f "$gtk_script" ]]; then
    printf "Error: %s does not exist.\n" "$gtk_script" >&2
    exit 1
fi

"$gtk_script"
