#!/usr/bin/env bash

set -euo pipefail

# pacman 官方仓库: https://archlinux.org/packages

# todo:
# breeze-cursor ?
# zathura, zathura-plugins-all ?
# 安装 Yay: https://wiki.archlinuxcn.org/wiki/Yay

# 音频驱动、固件和音频服务
sudo -E pacman -S --needed \
    sof-firmware \
    alsa-firmware \
    alsa-ucm-conf \
    pipewire \
    pipewire-jack \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber

# 图形界面配置相关
sudo -E pacman -S --needed \
    gtk3 \
    gtk4 \
    qt5-base \
    qt5-svg \
    qt5-wayland \
    qt5-x11extras \
    qt6-base \
    qt6-svg \
    qt6-wayland \
    nwg-look \
    qt5ct \
    qt6ct

# 字体:
sudo -E pacman -S --needed \
    noto-fonts-cjk \
    noto-fonts-emoji \
    inter-font

# 常用软件:
sudo -E pacman -S --needed \
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
    fd \
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
    less \
    mpv \
    nano \
    navi \
    neovim \
    nmap \
    obs-studio \
    ripgrep \
    rsync \
    rust \
    tealdeer \
    tmux \
    unzip \
    uv \
    vi \
    wget \
    yt-dlp \
    zsh \
    7zip \
    cargo-cache \
    xh \
    base-devel

# hyprland 相关:
sudo -E pacman -S --needed \
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
    tumbler \
    gvfs \
    udisks2 \
    thunar-volman \
    lf \
    duf \
    hyperfine \
    xdg-user-dirs \
    wl-clip-persist \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal \
    uwsm \
    libnewt

# todo 下载哪个 xdg-desktop-portal-gnome 还是 gtk, 决定
