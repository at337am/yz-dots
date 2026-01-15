#!/usr/bin/env bash

# 主题名称 = 目录名称
# 注意: 光标主题除了这里之外, 还需要去配置: 环境变量 和 WM 本身
gsettings set org.gnome.desktop.interface cursor-theme 'Breeze_Light'

# original 24
gsettings set org.gnome.desktop.interface cursor-size 30

# 如果以后换显示器了, 不再需要分数缩放了的话,
# 就把这个改回 1.0, 然后去调整 ~/.config 中的尺寸
# original 1.0
gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
gsettings set org.gnome.desktop.interface font-name 'Inter 12'
gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Pink-Light'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-grey'
