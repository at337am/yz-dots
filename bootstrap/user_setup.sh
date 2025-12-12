#!/usr/bin/env bash

set -euo pipefail

# 注意:
# 在后续使用中, 不要再手动执行 setup 中的脚本了
# setup 中的脚本都是一次性的, 不要重复执行, 避免出现错误
# 因为我懒得维护它们的健壮性了, 只允许用其他父脚本调用

scripts=(
    "setup/base.sh"
    "setup/pacman_mirrorlist.sh"
    "setup/pacman_install.sh"
    "setup/xdg-user-dirs.sh"
    "setup/sync_dotfiles.sh"
    "setup/symlink_dotfiles.sh"
    "setup/set_path_perms.sh"
    "setup/extract_p10k_theme.sh"
    "setup/fetch_fcitx5_dict.sh"
    "setup/misc_settings.sh"
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

printf "Amazing! Go ahead and enjoy your Arch Linux.\n"
