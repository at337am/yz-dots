#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if rpm -q code &>/dev/null; then
    echo "Script will not run again, skipping."
    return 0
fi

echo "Importing Microsoft GPG key..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo "Adding Visual Studio Code repository..."
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
    | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

echo "Checking DNF updates..."
sudo dnf check-update || true

echo "Starting installation..."
sudo dnf -y install code
