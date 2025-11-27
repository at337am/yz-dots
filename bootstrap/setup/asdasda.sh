#!/usr/bin/env bash

set -euo pipefail

config="# 设置 sudo 过期时间为 60 分钟
Defaults timestamp_timeout=60
# 所有终端共享 sudo 授权
Defaults !tty_tickets

# 保留代理环境变量
Defaults env_keep += \"http_proxy https_proxy no_proxy HTTP_PROXY HTTPS_PROXY NO_PROXY\"
"

tmp_file=$(mktemp)
trap 'rm -rf "$tmp_file"' EXIT

echo "$config" > "$tmp_file"

if sudo visudo -c -f "$tmp_file"; then
    target_file="/etc/sudoers.d/yz_custom_config"

    sudo install -m 440 "$tmp_file" "$target_file"
    printf "sudo configuration applied to $target_file\n"
else
    printf "Error: The generated configuration contains a syntax error.\n" >&2
    exit 1
fi

