#!/usr/bin/env bash

# 配置 GRUB 记住你上一次的选择

set -euo pipefail

grub_config="$HOME/Downloads/todo/grub"

if [[ ! -f "$grub_config" ]]; then
    printf "Error: %s does not exist.\n" "$grub_config" >&2
    exit 1
fi

set_grub_key() {
    local key="$1"
    local value="$2"

    local regex="^[#[:space:]]*${key}[[:space:]]*="

    # 检查该键是否存在 (无论是否被注释)
    if grep -E -q "$regex" "$GRUB_CONFIG"; then
        echo "更新配置: ${key}=${value}"
        # 使用 sed 替换整行
        sudo sed -i "s|${regex}.*|${key}=${value}|" "$grub_config"
    else
        echo "追加配置: ${key}=${value}"
        # 如果没找到，追加到文件末尾
        echo "${key}=${value}" | sudo tee -a "$grub_config" > /dev/null
    fi
}

# 将默认项设置为“已保存的项”
set_grub_key "GRUB_DEFAULT" "saved"

# 启用保存默认项功能
set_grub_key "GRUB_SAVEDEFAULT" "true"

# 禁用子菜单
set_grub_key "GRUB_DISABLE_SUBMENU" "y"

# sudo grub-mkconfig -o /boot/grub/grub.cfg

printf "Done.\n"
