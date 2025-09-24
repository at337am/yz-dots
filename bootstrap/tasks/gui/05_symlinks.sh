#!/usr/bin/env bash

set -euo pipefail

echo "开始对部分配置进行符号链接..."

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

if [[ ! -d "$DOTS_PATH" ]]; then
    echo "错误: yz-dots/home 目录不存在!"
    exit 1
fi

echo "创建符号链接 aliases.zsh..."
command rm -rf ~/.lain/lib/aliases.zsh
ln -s "$DOTS_PATH/.lain/lib/aliases.zsh" ~/.lain/lib/aliases.zsh

echo "创建符号链接 rime/custom_phrase.txt..."
command rm -rf ~/.local/share/fcitx5/rime/custom_phrase.txt && \
ln -s "$DOTS_PATH/.local/share/fcitx5/rime/custom_phrase.txt" ~/.local/share/fcitx5/rime/custom_phrase.txt

echo "创建 fastfetch 配置的符号链接..."
command rm -rf ~/.cache/fastfetch
command rm -rf ~/.config/fastfetch
ln -s "$DOTS_PATH/.config/fastfetch" ~/.config/fastfetch

echo "创建 fd 配置的符号链接..."
command rm -rf ~/.config/fd
ln -s "$DOTS_PATH/.config/fd" ~/.config/fd

echo "创建 hypr 配置的符号链接..."
command rm -rf ~/.config/hypr
ln -s "$DOTS_PATH/.config/hypr" ~/.config/hypr

echo "创建 kitty 配置的符号链接..."
command rm -rf ~/.config/kitty
ln -s "$DOTS_PATH/.config/kitty" ~/.config/kitty

echo "创建 mako 配置的符号链接..."
command rm -rf ~/.config/mako
ln -s "$DOTS_PATH/.config/mako" ~/.config/mako

echo "创建 mpv 配置的符号链接..."
command rm -rf ~/.config/mpv
ln -s "$DOTS_PATH/.config/mpv" ~/.config/mpv

echo "创建 navi 配置的符号链接..."
command rm -rf ~/.config/navi
ln -s "$DOTS_PATH/.config/navi" ~/.config/navi

echo "创建 nvim 配置的符号链接..."
command rm -rf \
        ~/.config/nvim \
        ~/.local/share/nvim \
        ~/.local/state/nvim \
        ~/.cache/nvim
ln -s "$DOTS_PATH/.config/nvim" ~/.config/nvim

echo "创建 rofi 配置的符号链接..."
command rm -rf ~/.config/rofi
ln -s "$DOTS_PATH/.config/rofi" ~/.config/rofi

echo "创建 waybar 配置的符号链接..."
command rm -rf ~/.config/waybar
ln -s "$DOTS_PATH/.config/waybar" ~/.config/waybar

echo "创建 yt-dlp 配置的符号链接..."
command rm -rf ~/.config/yt-dlp
ln -s "$DOTS_PATH/.config/yt-dlp" ~/.config/yt-dlp

echo "配置已链接完成"
