#!/usr/bin/env bash

set -euo pipefail

echo "开始克隆所有项目到指定位置..."

git clone git@github.com:at337am/notes.git ~/Documents/notes

git clone git@github.com:at337am/yz-dots.git ~/workspace/dev/yz-dots

git clone git@github.com:at337am/skit.git ~/workspace/dev/skit

git clone git@github.com:at337am/raindrop.git ~/workspace/dev/raindrop

echo "项目克隆完成"
