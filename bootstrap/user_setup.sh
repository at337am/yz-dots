#!/usr/bin/env bash

set -euo pipefail

# 注意:
# 在后续使用中, 不要再手动执行 tasks 中的脚本了
# tasks 中的脚本都是一次性的, 不要重复执行, 避免出现错误
# 因为我懒得维护它们的健壮性了, 只允许用其他父脚本调用

scripts=(
    "tasks/base.sh"
    "tasks/set_pacman_mirror.sh"
    "tasks/pacman_install.sh"
    "tasks/set_xdg_user_dirs.sh"
    "tasks/sync_dotfiles.sh"
    "tasks/symlink_dotfiles.sh"
    "tasks/set_path_perms.sh"
    "tasks/fetch_fcitx5_dict.sh"
    "tasks/misc_settings.sh"
    "tasks/build_yay.sh"
    "tasks/install_themes.sh"
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

    "$run" || {
        echo "" >&2
        echo "-------------- ERROR --------------" >&2
        echo "-=> $name failed to execute!" >&2
        echo "-----------------------------------" >&2
        exit 1
    }

    echo "-=> Completed: $name"
done

# 最后收尾
printf "\nFINAL STEP!\n\n"

# 清理多余的文件
sudo rm -rf /root/chroot_setup.sh

# 设置 zsh
chsh -s /usr/bin/zsh

printf "\nAmazing! Go ahead and enjoy your Arch Linux.\n"
