#!/usr/bin/env bash

set -euo pipefail

echo "开始安装 cargo-cache..."

cargo install cargo-cache

echo "cargo-cache 已安装"

echo "开始安装 xh..."

cargo install xh

echo "xh 已安装"
