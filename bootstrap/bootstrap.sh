#!/usr/bin/env bash

# 设置严格模式，任何错误都会导致脚本退出
set -euo pipefail

if [[ "$#" -ne 1 ]]; then
    printf "参数错误\n" >&2
    printf "用法: %s <代理地址>\n" "bootstrap.sh" >&2
    exit 1
fi

export http_proxy="$1"
export https_proxy="$1"
export HTTP_PROXY="$1"
export HTTPS_PROXY="$1"

echo "当前的代理地址: $http_proxy"

log() {
    printf '\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n-=> %s\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n\n' "$1"
}

# ------------- 执行脚本 START -------------- #
SCRIPT_DIR="tasks"

if [[ ! -d "$SCRIPT_DIR" ]]; then
    log "Error: 目录 '$SCRIPT_DIR' 不存在"
    exit 1
fi

find "$SCRIPT_DIR" -maxdepth 1 -name "*.sh" | sort -V | while read -r script; do
    log "开始执行脚本: $script"

    source "$script"

    exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log "Error: 脚本 '$script' 执行失败, 退出码: $exit_code"
        exit 1
    fi
done
# ------------- 执行脚本 END -------------- #


# 最后:
log "设置 zsh 为默认 shell..."
chsh -s /usr/bin/zsh
