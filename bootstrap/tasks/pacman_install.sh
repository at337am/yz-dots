#!/usr/bin/env bash

set -euo pipefail

# 音频驱动, 固件, 音频服务
sudo pacman -S --needed --noconfirm \
    sof-firmware \
    alsa-firmware \
    alsa-ucm-conf \
    pipewire \
    pipewire-jack \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber \
    libva-utils

# 图形界面配置相关
sudo pacman -S --needed --noconfirm \
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

# 字体
sudo pacman -S --needed --noconfirm \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    inter-font \
    ttf-jetbrains-mono \
    ttf-nerd-fonts-symbols \
    ttf-0xproto-nerd

# 通知音效主题
sudo pacman -S --needed --noconfirm \
    sound-theme-freedesktop

# 常用软件
sudo pacman -S --needed --noconfirm \
    foot \
    kitty \
    android-tools \
    bat \
    bc \
    catimg \
    cava \
    chafa \
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
    less \
    man-db \
    texinfo \
    mpv \
    nano \
    navi \
    neovim \
    nmap \
    ripgrep \
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
    base-devel \
    tree \
    lsof \
    exfatprogs \
    cowsay \
    udisks2 \
    lf \
    duf \
    hyperfine \
    cliphist \
    swww \
    mako \
    fortune-mod \
    grim \
    lxqt-policykit \
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
    thunar-volman \
    gvfs \
    xdg-user-dirs \
    wl-clip-persist \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal \
    libnewt \
    jq \
    exiftool \
    zathura \
    zathura-pdf-mupdf \
    tesseract-data-eng \
    tesseract-data-chi_sim \
    qt6-multimedia-ffmpeg \
    xorg-xlsclients \
    xorg-xwayland

# hyprland 相关
# sudo pacman -S --needed --noconfirm \
#     hyprland \
#     hypridle \
#     hyprlock \
#     hyprpicker \
#     xdg-desktop-portal-hyprland \
#     uwsm

# sway 相关
sudo pacman -S --needed --noconfirm \
    sway \
    swayidle \
    swaylock \
    xdg-desktop-portal-wlr

# 常用重量级 App
sudo pacman -S --needed --noconfirm \
    obsidian \
    telegram-desktop \
    discord \
    obs-studio \
    firefox


# ----- bak -----
# 
# mgba-qt
# 
# 
# 
# 目前不需要 监听 ACPI 事件 和 电源调度策略
# acpid power-profiles-daemon
# 
# 
# 
# 目前的壁纸工具为 swww
# 注意: swww 项目已改名为 awww, 但是目前 arch 官方仓库中还没有, 以后记得换!
# https://codeberg.org/LGFae/awww
# 
# 如果不在乎运行时切换壁纸的话, 可以使用 swaybg
# swaybg
