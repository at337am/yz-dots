# 自动设置终端窗口标题 (Auto Window Title)
autoload -Uz add-zsh-hook

# 命令结束/提示符出现时: 标题显示当前路径
function x_set_title_precmd() {
    print -Pn "\e]2;%~\a"
}

# 命令执行前: 标题显示完整命令
function x_set_title_preexec() {
    # 直接发送命令，不做任何长度检查
    # :gs/%/%% 为了防止输入 date +%s 时报错
    print -Pn "\e]2;${1:gs/%/%%}\a"
}

add-zsh-hook precmd x_set_title_precmd
add-zsh-hook preexec x_set_title_preexec
