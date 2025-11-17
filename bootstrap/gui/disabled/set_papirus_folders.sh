#!/usr/bin/env bash

set -euo pipefail

# 参考:
# icon 主题包: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
# 配色选择脚本: https://github.com/PapirusDevelopmentTeam/papirus-folders

if ! rpm -q papirus-icon-theme &>/dev/null; then
    sudo dnf -y install papirus-icon-theme
fi

if ! command -v "gsettings" &> /dev/null; then
    sudo dnf -y install glib2
fi

if ! command -v "papirus-folders" &> /dev/null; then
    wget -qO- https://git.io/papirus-folders-install | sh
fi

# 卸载 papirus-folders 脚本: 
# wget -qO- https://git.io/papirus-folders-install | env uninstall=true sh

# 更改 folder 配色
papirus-folders -C nordic --theme Papirus

# 设置图标主题
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

printf "Done.\n"
