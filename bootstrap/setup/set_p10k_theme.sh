#!/usr/bin/env bash

set -euo pipefail

# 解压 p10k 主题
tar -zxf ~/.lain/themes/powerlevel10k.tar.gz -C ~/.lain/themes
rm -rf ~/.lain/themes/powerlevel10k.tar.gz
