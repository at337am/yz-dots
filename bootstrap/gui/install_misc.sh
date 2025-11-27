#!/usr/bin/env bash

# 安装一些杂项 (不是很重要的东西)

set -euo pipefail

# 依赖检查
if ! command -v "yay" &> /dev/null; then
    printf "Error: Missing dependency: yay\n" >&2
    exit 1
fi

yay -S --needed \
    unimatrix-git \
    terminal-rain-lightning

# 额外安装一个 LTS 版本的内核 作为备用
# 后续若不需要了, 直接运行 -Rns 卸载即可
sudo pacman -S --needed --noconfirm \
    linux-lts \
    linux-lts-headers

# 更新引导程序
sudo grub-mkconfig -o /boot/grub/grub.cfg



# todo:
# 
# 配置 GRUB 记住你上一次的选择:
# 
# sudo nvim /etc/default/grub
# 
# 将默认项设置为“已保存的项”
# GRUB_DEFAULT=saved
# 启用保存默认项功能
# GRUB_SAVEDEFAULT=true

# ----- bak -----
# 
# sudo pacman -S mgba-qt
# sudo pacman -S obs-studio
