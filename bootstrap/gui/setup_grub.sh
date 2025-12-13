#!/usr/bin/env bash

set -euo pipefail

# 定义 GRUB 配置文件路径
GRUB_CONFIG="/etc/default/grub"

set_grub_option() {
    local key="$1"
    local value="$2"

    if grep -qE "^#?${key}=" "$GRUB_CONFIG"; then
        echo "更新: $key -> $value"
        sudo sed -i -E "s/^#?${key}=.*/${key}=${value}/" "$GRUB_CONFIG"
    else
        echo "追加: $key -> $value"
        echo "${key}=${value}" | sudo tee -a "$GRUB_CONFIG"
    fi
}

# 将默认项设置为“已保存的项”
set_grub_option "GRUB_DEFAULT" "saved"

# 启用保存默认项功能
set_grub_option "GRUB_SAVEDEFAULT" "true"

# 禁用子菜单
set_grub_option "GRUB_DISABLE_SUBMENU" "y"

sudo grub-mkconfig -o /boot/grub/grub.cfg

printf "Done.\n"
