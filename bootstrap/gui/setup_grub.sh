#!/usr/bin/env bash

set -euo pipefail

# 定义 GRUB 配置文件路径
GRUB_CONFIG="$HOME/Downloads/todo/grub"

set_grub_key() {
    local key="$1"
    local value="$2"

    # 使用 grep 检查该键是否存在（无论是否被注释）
    # 正则解释：
    # ^[[:space:]]*#?  -> 行首开始，可能有空格，可能有 #
    # [[:space:]]*     -> 可能有空格
    # ${key}=          -> 匹配键名和等号
    if grep -q "^[[:space:]]*#\?[[:space:]]*${key}=" "$GRUB_CONFIG"; then
        echo "更新配置: $key = $value"
        # 使用 sed 替换整行
        # s|Pattern|Replacement|
        # ^[[:space:]]*#\?[[:space:]]*${key}=.*  -> 匹配整行（包括注释符和旧值）
        # ${key}=${value}                        -> 替换为新值（去掉了注释）
        sudo sed -i "s|^[[:space:]]*#\?[[:space:]]*${key}=.*|${key}=${value}|" "$GRUB_CONFIG"
    else
        echo "追加配置: $key = $value"
        # 如果没找到，追加到文件末尾
        echo "${key}=${value}" | sudo tee -a "$GRUB_CONFIG" > /dev/null
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
