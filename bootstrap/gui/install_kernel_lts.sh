#!/usr/bin/env bash

set -euo pipefail

# 额外安装一个 LTS 版本的内核 作为备用
# 后续若不需要了, 直接运行 -Rns 卸载即可
sudo pacman -S --needed --noconfirm \
    linux-lts \
    linux-lts-headers

# 更新引导程序
sudo grub-mkconfig -o /boot/grub/grub.cfg
