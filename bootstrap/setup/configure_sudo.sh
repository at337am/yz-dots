#!/usr/bin/env bash

# 自定义 /etc/sudoers.d/ 中的配置
# 
# 大多数 Linux 发行版, sudo 默认会清除大部分环境变量, 包括与代理相关的变量, 
# 所以即使你在普通用户环境中设置了代理, sudo pacman 也无法使用它
# 
# 解决方法
#   方法一: 使用 sudo 的 -E 选项来继承当前用户环境变量
#   方法二: 在 /etc/sudoers 文件中允许保留特定变量

set -euo pipefail

config='# Set sudo timeout to 30 minutes
Defaults timestamp_timeout=30

# Share sudo authorization across all terminals
Defaults !tty_tickets

# Preserve proxy environment variables
Defaults env_keep += "http_proxy https_proxy no_proxy HTTP_PROXY HTTPS_PROXY NO_PROXY"
'

tmp_file=$(mktemp)
trap 'rm -rf "$tmp_file"' EXIT

echo "$config" > "$tmp_file"

if sudo visudo -cf "$tmp_file"; then
    target_file="/etc/sudoers.d/yz_custom_config"

    sudo install -m 440 "$tmp_file" "$target_file"
    printf "Success: sudo configuration has been applied to %s\n" "$target_file"
else
    printf "Error: The generated configuration contains syntax errors.\n" >&2
    exit 1
fi
