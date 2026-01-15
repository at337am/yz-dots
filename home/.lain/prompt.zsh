# zsh prompt theme

setopt prompt_subst

# --- 显示 Git 状态 ---

# 在启动时只检查一次 Git 是否存在
# 如果存在 Git，才定义真正的逻辑；否则定义一个空函数。
if (( $+commands[git] )); then

    # === 情况 A: 系统安装了 Git ===
    function get_git_status() {
        local branch

        # 获取分支名, 如果获取失败, 则直接返回
        branch=$(git symbolic-ref --short HEAD 2> /dev/null) || return

        # 颜色定义
        local color_branch="%F{magenta}"
        local color_arrow="%F{yellow}"
        local reset="%f"

        # 脏状态检测 (*)
        local dirty_symbol=""
        if [[ -n $(git status --porcelain 2> /dev/null) ]]; then
            dirty_symbol="*"
        fi

        # 箭头检测 (⇡ / ⇣)
        local arrows
        local ahead=0
        local behind=0

        local counts="$(git rev-list --left-right --count @{u}...HEAD 2>/dev/null)"

        if [[ -n "$counts" ]]; then
            read behind ahead <<< "$counts"
            (( ahead > 0 )) && arrows+=" ⇡"
            (( behind > 0 )) && arrows+=" ⇣"
        fi

        echo " ${color_branch}${branch}${dirty_symbol}${reset}${color_arrow}${arrows}${reset}"
    }

else

    # === 情况 B: 系统没有安装 Git ===
    function get_git_status() {
        return 0
    }

fi

# --- 输出一个空行 ---

typeset -g _prompt_needs_newline=

# precmd 钩子
precmd() {
    # 空行判断 (纯内存对比，极快)
    if [[ -n $_prompt_needs_newline ]]; then
        print "" 
    fi
    _prompt_needs_newline=true

    # 获取 Git 信息
    custom_git_info=$(get_git_status)
}

# 拦截清屏
alias clear='_prompt_needs_newline=; command clear'
alias reset='_prompt_needs_newline=; command reset'

# --- 最后组装 PROMPT ---

PROMPT='%F{cyan}%~%f${custom_git_info}
%(?.%F{green}.%F{red})❯%f '
