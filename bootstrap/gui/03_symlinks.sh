#!/usr/bin/env bash

set -euo pipefail

echo "Starting symbolic linking for selected configurations..."

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"

if [[ ! -d "$DOTS_PATH" ]]; then
    echo "Error: yz-dots/home directory does not exist!"
    exit 1
fi

command rm -rf ~/bin
ln -sv "$DOTS_PATH/bin" ~/bin

command rm -rf ~/.lain/lib/aliases.zsh
ln -sv "$DOTS_PATH/.lain/lib/aliases.zsh" ~/.lain/lib/aliases.zsh

command rm -rf ~/.local/share/fcitx5/rime/custom_phrase.txt && \
ln -sv "$DOTS_PATH/.local/share/fcitx5/rime/custom_phrase.txt" ~/.local/share/fcitx5/rime/custom_phrase.txt

command rm -rf ~/.cache/fastfetch
command rm -rf ~/.config/fastfetch
ln -sv "$DOTS_PATH/.config/fastfetch" ~/.config/fastfetch

command rm -rf ~/.config/fd
ln -sv "$DOTS_PATH/.config/fd" ~/.config/fd

command rm -rf ~/.config/hypr
ln -sv "$DOTS_PATH/.config/hypr" ~/.config/hypr

command rm -rf ~/.config/kitty
ln -sv "$DOTS_PATH/.config/kitty" ~/.config/kitty

command rm -rf ~/.config/mako
ln -sv "$DOTS_PATH/.config/mako" ~/.config/mako

command rm -rf ~/.config/mpv
ln -sv "$DOTS_PATH/.config/mpv" ~/.config/mpv

command rm -rf ~/.config/navi
ln -sv "$DOTS_PATH/.config/navi" ~/.config/navi

command rm -rf \
        ~/.config/nvim \
        ~/.local/share/nvim \
        ~/.local/state/nvim \
        ~/.cache/nvim
ln -sv "$DOTS_PATH/.config/nvim" ~/.config/nvim

command rm -rf ~/.config/rofi
ln -sv "$DOTS_PATH/.config/rofi" ~/.config/rofi

command rm -rf ~/.config/waybar
ln -sv "$DOTS_PATH/.config/waybar" ~/.config/waybar

command rm -rf ~/.config/yazi
ln -sv "$DOTS_PATH/.config/yazi" ~/.config/yazi

command rm -rf ~/.config/yt-dlp
ln -sv "$DOTS_PATH/.config/yt-dlp" ~/.config/yt-dlp

echo "Symlinking complete."
