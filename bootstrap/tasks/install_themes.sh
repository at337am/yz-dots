#!/usr/bin/env bash

# Orchis gtk theme: https://github.com/vinceliuice/Orchis-theme
# Tela-icon-theme: https://github.com/vinceliuice/Tela-icon-theme

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
sudo pacman -S --needed --noconfirm \
    gnome-themes-extra \
    sassc

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p ~/.local/share/themes
mkdir -p ~/.local/share/icons

gtk_themes(){
    # 卸载: ./install.sh --uninstall
    git clone --depth 1 https://github.com/vinceliuice/Orchis-theme.git "$tmp_dir/Orchis-theme"
    cd "$tmp_dir/Orchis-theme"
    ./install.sh \
        --theme pink \
        --color light \
        --size standard \
        --dest ~/.local/share/themes
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

# 刷新字体
fc-cache -f

gtk_themes
icon_themes
cursor_theme

# 最后设置主题
script="$HOME/.config/hypr/scripts/auto/gsettings.sh"

if [[ ! -f "$script" ]]; then
    printf "Error: %s does not exist.\n" "$script" >&2
    exit 1
fi

"$script"
