# 开启 Emacs 风格按键绑定, 这会作为默认键位表
bindkey -e

# 向上/下模糊搜索历史记录
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# 现代终端常用键位绑定 (Alacritty / Foot / Kitty 等通常都遵循这些标准序列)
bindkey "^[[A"    up-line-or-beginning-search    # 上箭头
bindkey "^[[B"    down-line-or-beginning-search  # 下箭头
bindkey "^[[H"    beginning-of-line              # Home 键 (部分终端)
bindkey "^[OH"    beginning-of-line              # Home 键 (备用序列)
bindkey "^[[F"    end-of-line                    # End 键 (部分终端)
bindkey "^[OF"    end-of-line                    # End 键 (备用序列)
bindkey "^[[Z"    reverse-menu-complete          # Shift-Tab
bindkey "^[[1;5C" forward-word                   # Ctrl+右箭头
bindkey "^[[1;5D" backward-word                  # Ctrl+左箭头

# 集成 navi
if command -v navi &> /dev/null; then
  eval "$(navi widget zsh)"
fi
