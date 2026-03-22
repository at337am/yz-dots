#!/usr/bin/env bash

# 设置一些路径的权限

set -euo pipefail

chmod 600 ~/.zshrc
chmod 600 ~/.zprofile

chmod 600 ~/.gitconfig

chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
