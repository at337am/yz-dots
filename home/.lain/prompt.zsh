# zsh prompt theme

setopt prompt_subst

# 在启动时检查 git 是否存在
if (( $+commands[git] )); then
    function get_git_status() {
        local branch

        # 获取分支名, 如果获取失败, 说明不是 git 仓库, 直接返回
        # 注意: 每次刷新 prompt 时, (即按下回车执行命令后), 都会执行一次 git symbolic-ref 操作
        # 不过请放心，这个耗时很短, 对性能影响很小, 可以忽略不计
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
    # 当 git 未安装时
    function get_git_status() {
        return 0
    }

fi

# --------------- 输出一个空行 ---------------
typeset -g _prompt_needs_newline=

# 关闭提示符换行后的自动前导空格, 防止空行内全是空格
# 而且, 关闭这个后，还可以解决「terminal 窗口大小发生变化时, 画面惨不忍睹」的问题
unsetopt PROMPT_SP

# 钩子
precmd() {
    # 当字符串非空, 换行
    [[ -n $_prompt_needs_newline ]] && print

    _prompt_needs_newline=true

    # 获取 git 信息
    custom_git_info=$(get_git_status)
}

# 拦截清屏命令
alias clear='_prompt_needs_newline=; command clear'
alias reset='_prompt_needs_newline=; command reset'

PROMPT='%F{cyan}%~%f${custom_git_info}
%(?.%F{green}.%F{red})❯%f '
