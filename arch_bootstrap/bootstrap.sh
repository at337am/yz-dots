#!/usr/bin/env bash

set -euo pipefail

scripts=(
    "setup/base.sh"
    "setup/pacman_install.sh"
    "setup/xdg-user-dirs.sh"
    "setup/rsync_home.sh"
    "setup/symlinks.sh"
    "setup/fcitx5.sh"
    "setup/configuration.sh"
    "setup/yay_install.sh"
    "setup/install_themes.sh"
)

# todo 检查每个脚本是否存在

for run in "${scripts[@]}"; do
    name=$(basename "$run")
    printf "-=> Running: %s\n" "$name"
    "$run"
    printf "-=> Completed: %s\n" "$name"
done

# finish
chsh -s /usr/bin/zsh

printf "You’re amazing! Go ahead and enjoy your Arch Linux.\n"
