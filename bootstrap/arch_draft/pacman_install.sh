#!/usr/bin/env bash

# todo:
# breeze-cursor ?
# qt5, qt6 ?
# zathura, zathura-plugins-all ?
# aur -> qimgv-git
# 安装 Yay: https://wiki.archlinuxcn.org/wiki/Yay

# sudo 用户执行 pacman 时, 不会识别 env 代理, 可以使用 -E 临时代理, 比如: sudo -E pacman -Syu
# 设置 pacman 永久代理:
# 编辑文件: /etc/pacman.conf 加上代理参数 -x:
# XferCommand = /usr/bin/curl -x http://127.0.0.1:2080 -L -C - -f -o %o %u

# 字体:
sudo pacman -S \
    noto-fonts-cjk \
    noto-fonts-emoji \
    inter-font

# 常用软件:
sudo pacman -S \
    android-tools \
    bat \
    catimg \
    cava \
    chafa \
    cmatrix \
    eza \
    fastfetch \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-rime \
    fd-find \
    ffmpeg \
    figlet \
    flatpak \
    fzf \
    git \
    go \
    htop \
    imagemagick \
    just \
    kitty \
    mpv \
    nano \
    navi \
    neovim \
    obs-studio \
    ripgrep \
    rust \
    tealdeer \
    tmux \
    uv \
    yt-dlp \
    zsh \
    7zip \

# hyprland 相关:
sudo pacman -S \
    cliphist \
    grim \
    hypridle \
    hyprland \
    hyprlock \
    hyprpaper \
    hyprpicker \
    lxqt-policykit \
    mako \
    network-manager-applet \
    rofi \
    slurp \
    waybar \
    wev \
    wl-clipboard \
    dbus \
    qalculate-gtk \
    mediainfo \
    pwgen \
    ffmpegthumbnailer \
    thunar \
    lf \
    duf \
    hyperfine
