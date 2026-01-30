#!/usr/bin/env bash

# 这里都是程序的配置软链接

set -euo pipefail

DOTS_PATH="/workspace/dev/yz-dots/home"

if [[ ! -d "$DOTS_PATH" ]]; then
    printf "Error: %s does not exist.\n" "$DOTS_PATH" >&2
    exit 1
fi

fcitx5(){
    rm -rf ~/.local/share/fcitx5/rime/custom_phrase.txt
    rm -rf ~/.local/share/fcitx5/rime/default.yaml
    rm -rf ~/.local/share/fcitx5/rime/yz_pinyin.schema.yaml
    rm -rf ~/.local/share/fcitx5/rime/yz_pinyin.dict.yaml
    rm -rf ~/.local/share/fcitx5/themes
    rm -rf ~/.config/fcitx5

    ln -sv "$DOTS_PATH/.local/share/fcitx5/rime/custom_phrase.txt" ~/.local/share/fcitx5/rime/custom_phrase.txt
    ln -sv "$DOTS_PATH/.local/share/fcitx5/rime/default.yaml" ~/.local/share/fcitx5/rime/default.yaml
    ln -sv "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.schema.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.schema.yaml
    ln -sv "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.dict.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.dict.yaml
    ln -sv "$DOTS_PATH/.local/share/fcitx5/themes" ~/.local/share/fcitx5/themes
    ln -sv "$DOTS_PATH/.config/fcitx5" ~/.config/fcitx5
}

vscode() {
    rm -rf ~/.config/Code/User/settings.json
    rm -rf ~/.config/Code/User/keybindings.json

    ln -sv "$DOTS_PATH/.config/Code/User/settings.json" ~/.config/Code/User/settings.json
    ln -sv "$DOTS_PATH/.config/Code/User/keybindings.json" ~/.config/Code/User/keybindings.json
}

# ------------- 如果脚本只接收到一个参数, 并且匹配 -------------

if [[ "$#" -eq 1 && "$1" == "fcitx5" ]]; then
    fcitx5
    exit 0
fi

if [[ "$#" -eq 1 && "$1" == "vscode" ]]; then
    vscode
    exit 0
fi

fcitx5
vscode

# ------------ .config ------------
# rm -rf ~/.config/cava
# ln -sv "$DOTS_PATH/.config/cava" ~/.config/cava

rm -rf ~/.lain
ln -sv "$DOTS_PATH/.lain" ~/.lain

rm -rf \
	~/.config/fastfetch \
	~/.cache/fastfetch
ln -sv "$DOTS_PATH/.config/fastfetch" ~/.config/fastfetch

rm -rf ~/.config/fd
ln -sv "$DOTS_PATH/.config/fd" ~/.config/fd

rm -rf ~/.config/fontconfig
ln -sv "$DOTS_PATH/.config/fontconfig" ~/.config/fontconfig

rm -rf ~/.config/hypr
ln -sv "$DOTS_PATH/.config/hypr" ~/.config/hypr

rm -rf ~/.config/kitty
ln -sv "$DOTS_PATH/.config/kitty" ~/.config/kitty

rm -rf ~/.config/lf
ln -sv "$DOTS_PATH/.config/lf" ~/.config/lf

rm -rf ~/.config/mako
ln -sv "$DOTS_PATH/.config/mako" ~/.config/mako

rm -rf ~/.config/mpv
ln -sv "$DOTS_PATH/.config/mpv" ~/.config/mpv

rm -rf ~/.config/navi
ln -sv "$DOTS_PATH/.config/navi" ~/.config/navi

rm -rf \
	~/.config/nvim \
	~/.local/share/nvim \
	~/.local/state/nvim \
	~/.cache/nvim
ln -sv "$DOTS_PATH/.config/nvim" ~/.config/nvim

rm -rf ~/.config/waybar
ln -sv "$DOTS_PATH/.config/waybar" ~/.config/waybar

# rm -rf ~/.config/xdg-desktop-portal
# ln -sv "$DOTS_PATH/.config/xdg-desktop-portal" ~/.config/xdg-desktop-portal

rm -rf ~/.config/yt-dlp
ln -sv "$DOTS_PATH/.config/yt-dlp" ~/.config/yt-dlp

rm -rf ~/.config/mimeapps.list
ln -sv "$DOTS_PATH/.config/mimeapps.list" ~/.config/mimeapps.list

rm -rf ~/.config/gtk-3.0/bookmarks
ln -sv "$DOTS_PATH/.config/gtk-3.0/bookmarks" ~/.config/gtk-3.0/bookmarks

rm -rf ~/.config/foot
ln -sv "$DOTS_PATH/.config/foot" ~/.config/foot

rm -rf ~/.config/sway
ln -sv "$DOTS_PATH/.config/sway" ~/.config/sway

rm -rf ~/.config/swaylock
ln -sv "$DOTS_PATH/.config/swaylock" ~/.config/swaylock

rm -rf ~/.config/swayidle
ln -sv "$DOTS_PATH/.config/swayidle" ~/.config/swayidle

rm -rf ~/.config/fuzzel
ln -sv "$DOTS_PATH/.config/fuzzel" ~/.config/fuzzel

rm -rf ~/.config/river
ln -sv "$DOTS_PATH/.config/river" ~/.config/river

rm -rf ~/.config/wob
ln -sv "$DOTS_PATH/.config/wob" ~/.config/wob

rm -rf ~/.config/wm-scripts
ln -sv "$DOTS_PATH/.config/wm-scripts" ~/.config/wm-scripts

rm -rf ~/.config/kanshi
ln -sv "$DOTS_PATH/.config/kanshi" ~/.config/kanshi
