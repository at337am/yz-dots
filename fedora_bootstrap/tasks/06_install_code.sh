#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if rpm -q code &>/dev/null; then
    echo "Skip: install_code.sh"
    return 0
fi

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
    | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

sudo dnf check-update || true

sudo dnf -y install code

echo "Visual Studio Code installation completed."
