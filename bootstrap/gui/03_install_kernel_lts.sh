#!/usr/bin/env bash

set -euo pipefail

# 额外安装一个 LTS 版本的内核 作为备用, 后续若不需要了, 直接运行 -Rns 卸载即可
sudo pacman -S --needed --noconfirm \
    linux-lts \
    linux-lts-headers

# ------>>> 配置 GRUB 记住你上一次的选择 <<<------

grub_config="/etc/default/grub"

if [[ ! -f "$grub_config" ]]; then
    printf "Error: %s does not exist.\n" "$grub_config" >&2
    exit 1
fi

# 第一次修改前先备份一次
if [[ ! -f "${grub_config}_default.bak" ]]; then
    sudo cp -a "$grub_config" "${grub_config}_default.bak"
    printf "配置已备份: %s\n" "${grub_config}_default.bak"
fi

set_grub_key() {
    local key="$1"
    local value="$2"

    local regex="^[#[:space:]]*${key}[[:space:]]*="

    # 检查该键是否存在 (无论是否被注释)
    if grep -E -q "$regex" "$grub_config"; then
        printf "updated: ${key}=${value}\n"
        # 使用 sed 替换整行
        sudo sed -i "s|${regex}.*|${key}=${value}|" "$grub_config"
    else
        printf "added: ${key}=${value}\n"
        # 如果没找到, 追加到文件末尾
        echo "${key}=${value}" | sudo tee -a "$grub_config" > /dev/null
    fi
}

# 将默认项设置为“已保存的项”
set_grub_key "GRUB_DEFAULT" "saved"

# 启用保存默认项功能
set_grub_key "GRUB_SAVEDEFAULT" "true"

# 禁用子菜单
set_grub_key "GRUB_DISABLE_SUBMENU" "y"

# 更新引导程序
sudo grub-mkconfig -o /boot/grub/grub.cfg

printf "Done.\n"
