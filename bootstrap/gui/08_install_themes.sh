#!/usr/bin/env bash

set -euo pipefail

# Orchis gtk theme: https://github.com/vinceliuice/Orchis-theme
# Tela-icon-theme: https://github.com/vinceliuice/Tela-icon-theme

if ! rpm -q gtk-murrine-engine &>/dev/null; then
    sudo dnf -y install gtk-murrine-engine
fi

if ! rpm -q gnome-themes-extra &>/dev/null; then
    sudo dnf -y install gnome-themes-extra
fi

if ! rpm -q sassc &>/dev/null; then
    sudo dnf -y install sassc
fi

tmp_dir=$(mktemp -d)
trap 'command rm -rf "$tmp_dir"' EXIT

mkdir -p ~/.local/share/themes
mkdir -p ~/.local/share/icons

# ---------------------- gtk themes ----------------------

# 卸载: install.sh --uninstall

git clone --depth 1 https://github.com/vinceliuice/Orchis-theme.git "$tmp_dir/Orchis-theme"

(
    cd "$tmp_dir/Orchis-theme"
    ./install.sh \
        --theme pink \
        --color light \
        --size standard \
        --dest ~/.local/share/themes
)

# ---------------------- icon themes ----------------------

# 卸载: install.sh -u

git clone --depth 1 https://github.com/vinceliuice/Tela-icon-theme.git "$tmp_dir/Tela-icon-theme"

(
    cd "$tmp_dir/Tela-icon-theme"
    ./install.sh grey -d ~/.local/share/icons
)

# 最后设置主题
~/.config/hypr/scripts/gsettings.sh
