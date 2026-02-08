#!/usr/bin/env bash

# 在 Termux 中启用存储访问, 执行命令: termux-setup-storage

set -euo pipefail

if [[ "${PREFIX:-}" != "/data/data/com.termux/files/usr" ]]; then
    printf "Error: Termux environment not detected.\n" >&2
    exit 1
fi

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Initialize Termux?"; then
    printf "Operation cancelled.\n" >&2
    exit 1
fi

syncs_path="$HOME/syncs"
dots_path="$syncs_path/dev/yz-dots/home"



# ------------- 检查所需文件 -------------
if [[ ! -d "$syncs_path" ]]; then
    printf "Error: %s does not exist.\n" "$syncs_path" >&2
    exit 1
fi



# ------------- 创建目录 -------------
mkdir -p ~/.config
mkdir -p ~/.local/share
mkdir -p ~/Downloads
mkdir -p ~/go/bin



# ------------- 下载必要的软件包 -------------
pkg upgrade

pkg install \
    rsync \
    git \
    zsh \
    golang \
    neovim \
    just \
    bat \
    fd \
    eza \
    ffmpeg \
    imagemagick \
    fastfetch \
    python-yt-dlp



# ------------- 同步需要的配置 -------------
rsync -a "$dots_path/.config/nvim/" ~/.config/nvim
rsync -a "$dots_path/.config/yt-dlp/" ~/.config/yt-dlp
rsync -a "$dots_path/.zshrc" ~/
rsync -a "$dots_path/.gitconfig" ~/
rsync -a "$dots_path/.lain" ~/
rsync -a "$dots_path/.zshrc" ~/



# ------------- 设置路径权限 -------------
chmod 600 ~/.zshrc
chmod 600 ~/.gitconfig



# ------------- misc -------------
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct



# ------------- dev install -------------
cd "$syncs_path/dev/skit"
just install-all

cd "$syncs_path/dev/raindrop"
just install

chsh -s /usr/bin/zsh

printf "Done.\n"
