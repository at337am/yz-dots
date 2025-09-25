#!/usr/bin/env bash

set -euo pipefail

sudo rm -rfv "/etc/dnf/dnf.conf"

sudo tee "/etc/dnf/dnf.conf" > /dev/null <<EOF
[main]
proxy=$http_proxy
EOF

echo "dnf 代理已设置"
