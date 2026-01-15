#!/usr/bin/env bash

# Yaru-Colors (GTK Theme): https://www.gnome-look.org/p/1299514
# Tela-icon-theme: https://www.gnome-look.org/p/1279924

set -euo pipefail

# 依赖检查
dependencies=("yay" "git")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

# 安装依赖 (gtk-engine-murrine 是 gtk2 的, 现在似乎已经不需要了)
# sudo pacman -S --needed --noconfirm \
#     gnome-themes-extra \
#     sassc

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p ~/.local/share/themes
mkdir -p ~/.local/share/icons

gtk_themes(){
    local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    tar -xf "$script_dir/static/gtk-themes.tar.xz" -C ~/.local/share/themes
}

icon_themes() {
    # 卸载: ./install.sh -u
    git clone --depth 1 https://github.com/vinceliuice/Tela-icon-theme.git "$tmp_dir/Tela-icon-theme"
    cd "$tmp_dir/Tela-icon-theme"
    ./install.sh grey -d ~/.local/share/icons
}

cursor_theme() {
    yay -S --needed --noconfirm xcursor-breeze
}

gtk_themes
icon_themes
cursor_theme

# 最后设置主题
gtk_script="$HOME/.config/wm-scripts/auto/gsettings.sh"

if [[ ! -f "$gtk_script" ]]; then
    printf "Error: %s does not exist.\n" "$gtk_script" >&2
    exit 1
fi

"$gtk_script"
