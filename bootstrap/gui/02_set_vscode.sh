#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "code" &> /dev/null; then
    printf "Error: Missing dependency: code\n" >&2
    exit 1
fi

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
extensions_list="$script_dir/static/vscode-extensions-list.txt"

# 备份 插件列表
bak_extensions_list() {
    code --list-extensions > "$extensions_list"
    printf "vscode 插件列表已生成 -> %s\n" "$extensions_list"
}

# 同步 插件和配置
sync_settings() {
    if [[ ! -f "$extensions_list" ]]; then
        printf "Error: %s does not exist.\n" "$extensions_list" >&2
        exit 1
    fi

    # 安装插件
    cat "$extensions_list" | xargs -L 1 code --install-extension
    printf "vscode 所有插件已安装完成\n"

    # 重新软链接 配置
    /workspace/dev/yz-dots/bootstrap/tasks/symlink_dotfiles.sh vscode
}

if [[ "$#" -eq 1 && "$1" == "bak" ]]; then
    bak_extensions_list
    printf "Done.\n"
    exit 0
fi

sync_settings
printf "Done.\n"
