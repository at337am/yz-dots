#!/usr/bin/env bash

set -euo pipefail

# 检查是否需要跳过
if rpm -q code &>/dev/null; then
    echo "此脚本不再重复执行, 跳过"
    exit 0
fi

echo "导入 Microsoft GPG 公钥..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo "添加 Visual Studio Code 仓库..."
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
    | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

echo "检查 dnf 更新..."
sudo dnf check-update || true

echo "开始安装..."
sudo dnf -y install code
