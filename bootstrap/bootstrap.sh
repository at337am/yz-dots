#!/usr/bin/env bash

set -euo pipefail

scripts=(
    "setup/base.sh"
    "setup/pacman_install.sh"
    "setup/xdg-user-dirs.sh"
    "setup/rsync_home.sh"
    "setup/path_perms.sh"
    "setup/symlinks.sh"
    "setup/fcitx5.sh"
    "setup/configuration.sh"
    "setup/yay_install.sh"
    "setup/install_themes.sh"
)

# 路径检查
for path in "${scripts[@]}"; do
    if [[ ! -f "$path" ]]; then
        printf "Error: %s does not exist.\n" "$path" >&2
        exit 1
    fi
done

# 依次执行每个脚本
for run in "${scripts[@]}"; do
    name=$(basename "$run")
    echo "-=> Running: $name"
    "$run"
    echo "-=> Completed: $name"
done

# finish
chsh -s /usr/bin/zsh

printf "You’re amazing! Go ahead and enjoy your Arch Linux.\n"
