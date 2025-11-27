#!/usr/bin/env bash

# 自定义 /etc/sudoers.d/ 中的配置

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
