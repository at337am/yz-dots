# 用于替代默认的 rm 命令, 实现"回收站式删除"
# 注意: 不要在 U 盘挂载目录使用, 直接 sudo rm 就行了
rm() {
    # 检查环境变量
    if [[ ! -n "${TRASH_DIR+1}" ]]; then
        printf "Error: TRASH_DIR variable not set.\n" >&2
        return 1
    fi

    # 检查参数
    if [[ "$#" -eq 0 ]]; then
        printf "Error: Invalid arguments.\n" >&2
        printf "Usage: rm <path>...\n" >&2
        return 1
    fi

    # 禁止在 HOME 目录下批量删除
    if [[ "$PWD" == "$HOME" && "$#" -ge 2 ]]; then
        printf "\033[31mrm: Do not bulk remove under HOME!\033[0m\n" >&2
        return 1
    fi

    local item

    # 检查参数指定的路径是否存在且不是符号链接
    for item in "$@"; do
        if [[ ! -e "$item" && ! -L "$item" ]]; then
            printf "Error: '%s' does not exist.\n" "$item" >&2
            printf "No items were moved.\n" >&2
            return 1
        fi
    done

    # 检查回收站目录是否存在, 不存在则创建它
    if [[ ! -d "$TRASH_DIR" ]]; then
        if ! mkdir -p "$TRASH_DIR"; then
            printf "Error: Failed to create the trash directory at '%s'.\n" "$TRASH_DIR" >&2
            return 1
        fi
    fi

    local move_failed=0

    # 遍历所有参数进行移动
    for item in "$@"; do
        local base_name=$(basename -- "$item")
        local destination_path="${TRASH_DIR}/$(date +%y%m%d_%H%M%S_%N)_${base_name}"

        # 使用 '--' 明确后续为路径参数
        if ! mv -- "$item" "$destination_path"; then
            printf "\033[35mrm: '%s' may have been moved.\033[0m\n" "$item" >&2
            move_failed=1

            # 跳到下一个循环
            continue
        fi

        printf "rm: %s -> %s\n" "$item" "$destination_path"
    done

    return $move_failed
}

# 用于清空自定义回收站目录中的所有内容
cl_trash() {
    if [[ -d "$TRASH_DIR" && -z "$(find "$TRASH_DIR" -mindepth 1 -print -quit)" ]]; then
        printf "Trash is clean.\n"
        return 0
    fi

    command rm -rfv -- "${TRASH_DIR}/"*(D)
}

# 创建一个新目录, 并进入该目录
# 若新目录已存在, 则不执行
mkcd() {
    if [[ "$#" -ne 1 ]]; then
        printf "Error: Invalid arguments.\n" >&2
        printf "Usage: mkcd <new-dir>\n" >&2
        return 1
    fi

    if [[ -e "$1" || -L "$1" ]]; then
        printf "Error: '%s' already exists.\n" "$1" >&2
        return 1
    fi

    mkdir -p -- "$1" && cd -- "$1"
}

# 创建一个新目录, 并将一个或多个指定文件或目录移动到该目录中
# 若新目录已存在, 则不执行
mkmv() {
    # 检查参数
    if [[ "$#" -lt 2 ]]; then
        printf "Error: Invalid arguments.\n" >&2
        printf "Usage: mkmv <path>... <new-dir>\n" >&2
        return 1
    fi

    # 禁止在 HOME 目录下批量移动
    if [[ "$PWD" == "$HOME" && "$#" -ge 3 ]]; then
        printf "\033[31mmkmv: Do not bulk move under HOME!\033[0m\n" >&2
        return 1
    fi

    # 将最后一个参数视为目标目录名称
    local new_dir="${@[-1]}"

    # 除最后一个参数外, 其余均视为需要移动的源文件或目录路径列表
    local paths=("${(@)@[1,-2]}")

    # 判断目标目录是否已存在, 若存在则报错并退出
    if [[ -e "$new_dir" ]]; then
        printf "Error: Target '%s' already exists.\n" "$new_dir" >&2
        return 1
    fi

    local p

    # 逐个检查所有源路径是否存在, 若有任意不存在则立即停止并提示错误
    for p in "${paths[@]}"; do
        if [[ ! -e "$p" ]]; then
            printf "Error: Source '%s' does not exist.\n" "$p" >&2
            return 1
        fi
    done

    # 创建目标目录 (支持递归创建), 并将所有源文件/目录移动到该目录中
    if mkdir -p "$new_dir" && mv -- "${paths[@]}" "$new_dir/"; then
        printf "\033[32mmkmv: Created %s/ and moved %d item(s) inside.\033[0m\n" "$new_dir" "${#paths[@]}"
        return 0
    else
        printf "Error: Failed to create directory or move items. Check permissions.\n" >&2
        return 1
    fi
}

# 备份一个文件
bak() {
    if [[ "$#" -ne 1 ]]; then
        printf "Error: Invalid arguments.\n" >&2
        printf "Usage: bak <file>\n" >&2
        return 1
    fi

    local source_file="$1"

    if [[ ! -f "$source_file" && ! -L "$source_file" ]]; then
        printf "Error: '%s' is not a regular file.\n" "$source_file" >&2
        return 1
    fi

    cp -a -- "$source_file" "${source_file}_$(date +%y%m%d_%H%M%S_%N).bak"
}

# 复制一个或多个文件的 URI
cpf() {
    if [[ "$#" -eq 0 ]]; then
        printf "Error: Invalid arguments.\n" >&2
        printf "Usage: cpf <files...>\n" >&2
        return 1
    fi

    local uri_list=""
    local file

    for file in "$@"; do
        if [[ ! -f "$file" ]]; then
            printf "Error: '%s' is not a regular file.\n" "$file" >&2
            return 1
        fi
        uri_list="${uri_list}file://${file:A}\n"
    done

    if [[ -n "$uri_list" ]]; then
        print -n -- "$uri_list" | wl-copy --type text/uri-list
        print "Copied:"
        print -n -- "$uri_list"
    fi
}

d() {
    if [[ "$#" -ne 0 ]]; then
        return 1
    fi

    dirs -v | head -n 10
}

# 方便打开一些媒体文件
o() {
    if [[ "$#" -ne 1 ]]; then
        printf "Error: Invalid arguments.\n" >&2
        printf "Usage: o <file>\n" >&2
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        printf "Error: '%s' does not exist.\n" "$1" >&2
        return 1
    fi

    local ext="${1##*.}"
    ext="${ext:l}"

    case "$ext" in
        jpg|jpeg|png|gif|webp)
            qimgv "$1"
            ;;
        mp4|mkv|mov|mp3|flac|m4a|m4v|webm|ts|avi)
            mpv "$1"
            ;;
        pdf)
            zathura "$1"
            ;;
        *)
            printf "Error: Unknown extension: %s\n" "$ext" >&2
            return 1
            ;;
    esac
}
