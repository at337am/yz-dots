#!/usr/bin/env bash

set -euo pipefail

rm -rf ~/.cache/fastfetch

rm -rf ~/.local/share/nvim \
        ~/.local/state/nvim \
        ~/.cache/nvim

DOTS_PATH="$HOME/workspace/dev/yz-dots/home"


# ------------ HOME ------------
ln -sf "$HOME/workspace/dev/yz-dots/tidy" ~/tidy
ln -sf "$DOTS_PATH/bin" ~/bin



# ------------ CONFIG ------------
ln -sf "$DOTS_PATH/.config/cava" ~/.config/cava
ln -sf "$DOTS_PATH/.config/fastfetch" ~/.config/fastfetch
ln -sf "$DOTS_PATH/.config/fd" ~/.config/fd
ln -sf "$DOTS_PATH/.config/hypr" ~/.config/hypr
ln -sf "$DOTS_PATH/.config/kitty" ~/.config/kitty
ln -sf "$DOTS_PATH/.config/lf" ~/.config/lf
ln -sf "$DOTS_PATH/.config/mako" ~/.config/mako
ln -sf "$DOTS_PATH/.config/mpv" ~/.config/mpv
ln -sf "$DOTS_PATH/.config/navi" ~/.config/navi
ln -sf "$DOTS_PATH/.config/nvim" ~/.config/nvim
ln -sf "$DOTS_PATH/.config/rofi" ~/.config/rofi
ln -sf "$DOTS_PATH/.config/Thunar" ~/.config/Thunar
ln -sf "$DOTS_PATH/.config/waybar" ~/.config/waybar
ln -sf "$DOTS_PATH/.config/yt-dlp" ~/.config/yt-dlp
ln -sf "$DOTS_PATH/.config/mimeapps.list" ~/.config/mimeapps.list



# ------------ ZSH ------------
ln -sf "$DOTS_PATH/.lain/lib/aliases.zsh" ~/.lain/lib/aliases.zsh
ln -sf "$DOTS_PATH/.lain/lib/func.zsh" ~/.lain/lib/func.zsh



# ------------ FCITX5 ------------
ln -sf "$DOTS_PATH/.local/share/fcitx5/rime/custom_phrase.txt" ~/.local/share/fcitx5/rime/custom_phrase.txt
ln -sf "$DOTS_PATH/.local/share/fcitx5/rime/default.yaml" ~/.local/share/fcitx5/rime/default.yaml
ln -sf "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.schema.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.schema.yaml
ln -sf "$DOTS_PATH/.local/share/fcitx5/rime/yz_pinyin.dict.yaml" ~/.local/share/fcitx5/rime/yz_pinyin.dict.yaml
ln -sf "$DOTS_PATH/.local/share/fcitx5/themes" ~/.local/share/fcitx5/themes
ln -sf "$DOTS_PATH/.config/fcitx5" ~/.config/fcitx5
