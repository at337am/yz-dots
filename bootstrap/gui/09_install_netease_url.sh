#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
dependencies=("uv" "git")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to install Netease_url?"; then
    printf "Operation cancelled.\n" >&2
    exit 1
fi

destination="/opt/soft/Netease_url"

# 先清理旧的项目
rm -rf "$destination"

# ------------- 拉取项目 -------------
git clone https://github.com/Suxiaoqinx/Netease_url.git "$destination"

cd "$destination"

rm -rf .git .github

uv venv .venv
uv pip install -r requirements.txt

printf "Done.\n"

# 后续:
# 填入自己的 cookie.txt
# 
# ----- 启动项目 -----
# source .venv/bin/activate
# python main.py
# 或者直接:
# uv run python main.py
