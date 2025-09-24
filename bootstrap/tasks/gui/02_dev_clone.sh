#!/usr/bin/env bash

set -euo pipefail

echo "开始克隆所有项目到 dev..."

git clone git@github.com:at337am/yz-dots.git ~/workspace/dev/yz-dots

git clone git@github.com:at337am/notes.git ~/workspace/dev/notes

git clone git@github.com:at337am/skit.git ~/workspace/dev/skit

git clone git@github.com:at337am/raindrop.git ~/workspace/dev/raindrop

echo "dev 项目克隆完成"
