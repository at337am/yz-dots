#!/usr/bin/env bash

set -euo pipefail

# Orchis gtk theme: https://www.gnome-look.org/p/1357889
# Tela-icon-theme: https://www.gnome-look.org/p/1279924

if ! rpm -q gtk-murrine-engine &>/dev/null; then
    sudo dnf -y install gtk-murrine-engine
fi

if ! rpm -q gnome-themes-extra &>/dev/null; then
    sudo dnf -y install gnome-themes-extra
fi

# todo 使用自动化脚本安装主题
