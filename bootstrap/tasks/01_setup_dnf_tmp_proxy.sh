#!/usr/bin/env bash

set -euo pipefail

PROXY_LINE="proxy=$http_proxy"
CONF_FILE="/etc/dnf/dnf.conf"
PROXY_PATTERN="^proxy="

if [[ -f "$CONF_FILE" ]] && grep -q "$PROXY_PATTERN" "$CONF_FILE"; then
    echo "检测到 '$CONF_FILE' 中已存在代理配置, 跳过"
    exit 0
fi

echo "$PROXY_LINE" | sudo tee -a "$CONF_FILE"

echo "dnf 临时代理已设置"
