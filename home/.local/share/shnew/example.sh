#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
# if ! command -v "magick" &> /dev/null; then
#     printf "Error: Missing dependency: magick\n" >&2
#     exit 1
# fi

# if [[ "$#" -ne 1 ]]; then
#     printf "Error: Invalid arguments.\n" >&2
#     printf "Usage: %s <path>\n" "$(basename "$0")" >&2
#     exit 1
# fi

# 脚本所在目录
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

printf "Done.\n"
