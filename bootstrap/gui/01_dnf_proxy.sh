#!/usr/bin/env bash

set -euo pipefail

sudo rm -rfv "/etc/dnf/dnf.conf"

sudo tee "/etc/dnf/dnf.conf" > /dev/null <<EOF
[main]
proxy=http://127.0.0.1:2080
EOF

echo "DNF Proxy configured."
