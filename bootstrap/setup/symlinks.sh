#!/usr/bin/env bash

set -euo pipefail

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

if [[ ! -d "$DOTS_PATH" ]]; then
    printf "Error: %s does not exist.\n" "$DOTS_PATH" >&2
    exit 1
fi

# ------------ HOME ------------
rm -rf ~/tidy
ln -s "$HOME/workspace/dev/yz-dots/tidy" ~/tidy

rm -rf ~/bin
ln -s "$DOTS_PATH/bin" ~/bin



# ------------ CONFIG ------------
rm -rf ~/.config/cava
ln -s "$DOTS_PATH/.config/cava" ~/.config/cava

rm -rf \
	~/.config/fastfetch \
	~/.cache/fastfetch
ln -s "$DOTS_PATH/.config/fastfetch" ~/.config/fastfetch

rm -rf ~/.config/fd
ln -s "$DOTS_PATH/.config/fd" ~/.config/fd

rm -rf ~/.config/hypr
ln -s "$DOTS_PATH/.config/hypr" ~/.config/hypr

rm -rf ~/.config/kitty
ln -s "$DOTS_PATH/.config/kitty" ~/.config/kitty

rm -rf ~/.config/lf
ln -s "$DOTS_PATH/.config/lf" ~/.config/lf

rm -rf ~/.config/mako
ln -s "$DOTS_PATH/.config/mako" ~/.config/mako

rm -rf ~/.config/mpv
ln -s "$DOTS_PATH/.config/mpv" ~/.config/mpv

rm -rf ~/.config/navi
ln -s "$DOTS_PATH/.config/navi" ~/.config/navi

rm -rf \
	~/.config/nvim \
	~/.local/share/nvim \
	~/.local/state/nvim \
	~/.cache/nvim
ln -s "$DOTS_PATH/.config/nvim" ~/.config/nvim

rm -rf ~/.config/rofi
ln -s "$DOTS_PATH/.config/rofi" ~/.config/rofi

rm -rf ~/.config/Thunar
ln -s "$DOTS_PATH/.config/Thunar" ~/.config/Thunar

rm -rf ~/.config/waybar
ln -s "$DOTS_PATH/.config/waybar" ~/.config/waybar

rm -rf ~/.config/yt-dlp
ln -s "$DOTS_PATH/.config/yt-dlp" ~/.config/yt-dlp

rm -rf ~/.config/mimeapps.list
ln -s "$DOTS_PATH/.config/mimeapps.list" ~/.config/mimeapps.list



# ------------ ZSH ------------
rm -rf ~/.lain/lib/aliases.zsh
rm -rf ~/.lain/lib/func.zsh

ln -s "$DOTS_PATH/.lain/lib/aliases.zsh" ~/.lain/lib/aliases.zsh
ln -s "$DOTS_PATH/.lain/lib/func.zsh" ~/.lain/lib/func.zsh



# ------------ FCITX5 ------------
fcitx5(){
    rm -rf ~/.local/share/fcitx5/rime/custom_phrase.txt
    rm -rf ~/.local/share/fcitx5/rime/default.yaml
    rm -rf ~/.local/share/fcitx5/rime/yz_pinyin.schema.yaml
    rm -rf ~/.local/share/fcitx5/rime/yz_pinyin.dict.yaml
    rm -rf ~/.local/share/fcitx5/themes
    rm -rf ~/.config/fcitx5

    ln -s "$DOTS_PATH/.local/share/fcitx5/rime/custom_phrase.txt" ~/.local/share/fcitx5/rime/custom_phrase.txt
    ln -s "$DOTS_PATH/.local/share/fcitx5/rime/default.yaml" ~/.local/share/fcitx5/rime/default.yaml
    ln -s "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.schema.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.schema.yaml
    ln -s "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.dict.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.dict.yaml
    ln -s "$DOTS_PATH/.local/share/fcitx5/themes" ~/.local/share/fcitx5/themes
    ln -s "$DOTS_PATH/.config/fcitx5" ~/.config/fcitx5
}

# 只要参数数量为 0 或第一个参数是 fcitx5
if [[ "$#" -eq 0 || "$1" == "fcitx5" ]]; then
    fcitx5
fi
