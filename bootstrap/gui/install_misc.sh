#!/usr/bin/env bash

# 安装一些杂项 (不是很重要的东西)

set -euo pipefail

# 依赖检查
if ! command -v "yay" &> /dev/null; then
    printf "Error: Missing dependency: yay\n" >&2
    exit 1
fi

# 额外安装一个 LTS 版本的内核 作为备用, 后续若不需要了, 直接运行 -Rns 卸载即可
sudo pacman -S --needed --noconfirm \
    linux-lts \
    linux-lts-headers

# 别忘了更新引导程序
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 一些有趣的东西
yay -S --needed \
    unimatrix-git \
    terminal-rain-lightning

sudo pacman -S --needed --noconfirm \
    obs-studio



# ----- bak -----
# 
# sudo pacman -S mgba-qt
