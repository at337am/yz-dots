#!/usr/bin/env bash

set -euo pipefail

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to reset symlinks?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

command rm -rf ~/tidy
ln -s "$HOME/workspace/dev/yz-dots/tidy" ~/tidy

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

command rm -rf ~/bin
ln -s "$DOTS_PATH/bin" ~/bin

command rm -rf ~/.lain/lib/aliases.zsh
ln -s "$DOTS_PATH/.lain/lib/aliases.zsh" ~/.lain/lib/aliases.zsh

command rm -rf ~/.lain/lib/func.zsh
ln -s "$DOTS_PATH/.lain/lib/func.zsh" ~/.lain/lib/func.zsh

command rm -rf ~/.config/cava
ln -s "$DOTS_PATH/.config/cava" ~/.config/cava

command rm -rf ~/.cache/fastfetch
command rm -rf ~/.config/fastfetch
ln -s "$DOTS_PATH/.config/fastfetch" ~/.config/fastfetch

command rm -rf ~/.config/fd
ln -s "$DOTS_PATH/.config/fd" ~/.config/fd

command rm -rf ~/.config/hypr
ln -s "$DOTS_PATH/.config/hypr" ~/.config/hypr

command rm -rf ~/.config/kitty
ln -s "$DOTS_PATH/.config/kitty" ~/.config/kitty

command rm -rf ~/.config/lf
ln -s "$DOTS_PATH/.config/lf" ~/.config/lf

command rm -rf ~/.config/mako
ln -s "$DOTS_PATH/.config/mako" ~/.config/mako

command rm -rf ~/.config/mpv
ln -s "$DOTS_PATH/.config/mpv" ~/.config/mpv

command rm -rf ~/.config/navi
ln -s "$DOTS_PATH/.config/navi" ~/.config/navi

command rm -rf \
        ~/.config/nvim \
        ~/.local/share/nvim \
        ~/.local/state/nvim \
        ~/.cache/nvim
ln -s "$DOTS_PATH/.config/nvim" ~/.config/nvim

command rm -rf ~/.config/rofi
ln -s "$DOTS_PATH/.config/rofi" ~/.config/rofi

command rm -rf ~/.config/waybar
ln -s "$DOTS_PATH/.config/waybar" ~/.config/waybar

command rm -rf ~/.config/yt-dlp
ln -s "$DOTS_PATH/.config/yt-dlp" ~/.config/yt-dlp

command rm -rf ~/.config/mimeapps.list
ln -s "$DOTS_PATH/.config/mimeapps.list" ~/.config/mimeapps.list


# ------------ fcitx5 START ------------
command rm -rf ~/.local/share/fcitx5/rime/custom_phrase.txt
command rm -rf ~/.local/share/fcitx5/rime/default.yaml
command rm -rf ~/.local/share/fcitx5/rime/yz_pinyin.schema.yaml
command rm -rf ~/.local/share/fcitx5/rime/yz_pinyin.dict.yaml
command rm -rf ~/.local/share/fcitx5/themes
command rm -rf ~/.config/fcitx5

ln -s "$DOTS_PATH/.local/share/fcitx5/rime/custom_phrase.txt" ~/.local/share/fcitx5/rime/custom_phrase.txt
ln -s "$DOTS_PATH/.local/share/fcitx5/rime/default.yaml" ~/.local/share/fcitx5/rime/default.yaml
ln -s "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.schema.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.schema.yaml
ln -s "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.dict.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.dict.yaml
ln -s "$DOTS_PATH/.local/share/fcitx5/themes" ~/.local/share/fcitx5/themes
ln -s "$DOTS_PATH/.config/fcitx5" ~/.config/fcitx5
# ------------ fcitx5 END ------------




printf "Done.\n"
