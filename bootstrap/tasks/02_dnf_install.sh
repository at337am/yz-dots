#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if rpm -q hyprland &>/dev/null; then
    echo "Script will not run again, skipping."
    return 0
fi

enable_copr_repo() {
    local repo_owner="$1"
    local repo_project="$2"
    local repo_pattern="${repo_owner}:${repo_project}" # 例如 "solopasha:hyprland"

    if dnf repolist | grep -q "$repo_pattern"; then
        echo "COPR repository for ${repo_pattern} is already enabled, skipping."
    else
        echo "Enabling COPR repository for ${repo_pattern}..."
        if sudo dnf -y copr enable "${repo_owner}/${repo_project}"; then
            echo "COPR repository for ${repo_pattern} successfully enabled."
        else
            echo "Error: Failed to enable COPR repository for ${repo_pattern}!"
            return 1
        fi        
    fi
}



# -------------------------------- #
echo "Starting cleanup of unused packages..."

sudo dnf -y autoremove

echo "Unused package cleanup complete."
# -------------------------------- #



# ------------------------------- REPO START -------------------------------

# 更多镜像地址: https://mirrors.rpmfusion.org/mm/publiclist

if dnf repolist | grep -q "rpmfusion-free" && dnf repolist | grep -q "rpmfusion-nonfree"; then
    echo "RPM Fusion repositories already enabled, skipping."
else
    echo "Installing RPM Fusion repositories..."

    sudo dnf -y install \
        "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
        "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    # bak:

    # sudo dnf install \
    #     "https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    #     "https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    # sudo dnf -y install \
    #     "https://mirror.math.princeton.edu/pub/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
    #     "https://mirror.math.princeton.edu/pub/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

    echo "RPM Fusion repositories successfully installed."
fi

enable_copr_repo "solopasha" "hyprland"
enable_copr_repo "alternateved" "eza"
enable_copr_repo "ecomaikgolf" "lf"

# ------------------------------- REPO END -------------------------------



echo "Updating DNF metadata cache..."

sudo dnf makecache

echo "All repositories are ready."



# ------------------------------- INSTALL START -------------------------------
# -------------------------------- #
echo "Starting installation of base software group..."

sudo dnf -y group install \
    "c-development" \
    "development-tools" \
    "multimedia"

echo "Base software group installation complete."
# -------------------------------- #



# -------------------------------- #
echo "Removing redundant libva-intel-media-driver..."

# 因为上面 multimedia 安装了旧的 libva-intel-media-driver
# 需要先删除, 下面会安装新的 intel-media-driver 以适应 Intel 5 代以上的机型
# 参考: https://github.com/devangshekhawat/Fedora-42-Post-Install-Guide?tab=readme-ov-file#hw-video-decoding-with-va-api
sudo dnf -y remove libva-intel-media-driver

echo "Removed: libva-intel-media-driver"
# -------------------------------- #



# -------------------------------- #
echo "Installing graphics and hardware acceleration packages..."

sudo dnf -y install \
    glx-utils \
    intel-media-driver \
    libva-intel-driver \
    libva-utils \
    mesa-vdpau-drivers \
    vulkan-tools

echo "Graphics and acceleration packages installed."
# -------------------------------- #



# -------------------------------- #
echo "Installing fonts and cursor themes..."

sudo dnf -y install \
    adwaita-sans-fonts.noarch \
    breeze-cursor-theme \
    google-noto-color-emoji-fonts \
    google-noto-sans-cjk-vf-fonts

echo "Fonts and cursor themes installed."
# -------------------------------- #



# -------------------------------- #
echo "Installing common packages..."

sudo dnf -y install \
    adb \
    bat \
    cargo \
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
    go \
    htop \
    ImageMagick \
    just \
    kitty \
    mpv \
    navi \
    neovim \
    p7zip \
    pandoc \
    qimgv \
    ripgrep \
    rust \
    tealdeer \
    tmux \
    uv \
    yt-dlp \
    zsh \
    obs-studio \
    nano

echo "Common packages installed."
# -------------------------------- #



# -------------------------------- #
echo "Installing Hyprland and related packages..."

sudo dnf -y install \
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
    qt5-qtwayland \
    qt6-qtwayland \
    rofi-wayland \
    slurp \
    waybar \
    wev \
    wl-clipboard \
    dbus-daemon \
    langpacks-zh_CN \
    zathura \
    zathura-plugins-all \
    qalculate \
    mediainfo \
    pwgen \
    ffmpegthumbnailer \
    thunar \
    lf

echo "Hyprland and related packages installed."
# -------------------------------- #



# -------------------------------- #
echo "Installing ACPI event daemon and power services..."

sudo dnf -y install \
    acpid \
    power-profiles-daemon

echo "ACPI daemon and power services installed."
# -------------------------------- #



# -------------------------------- #
echo "Enabling ACPI event daemon and power services..."

if systemctl is-enabled --quiet power-profiles-daemon.service; then
    echo "power-profiles-daemon.service already enabled, skipping."
else
    sudo systemctl enable --now power-profiles-daemon.service
    echo "power-profiles-daemon.service enabled."
fi

if systemctl is-enabled --quiet acpid.service; then
    echo "acpid.service already enabled, skipping."
else
    sudo systemctl enable --now acpid.service
    echo "acpid.service enabled."
fi
# -------------------------------- #
# ------------------------------- INSTALL END -------------------------------



# -------------------------------- #
echo "Starting cleanup of unused packages..."

sudo dnf -y remove \
    vim-enhanced \
    ccache \
    wofi

sudo dnf -y autoremove

echo "Unused package cleanup complete."
# -------------------------------- #
