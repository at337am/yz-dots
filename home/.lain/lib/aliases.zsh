# misc
alias v='nvim'
alias px='http_proxy=http://127.0.0.1:2080 https_proxy=http://127.0.0.1:2080'
alias yt='yt-dlp'
alias fpi='px flatpak install --user -y flathub'
alias fm='thunar . > /dev/null 2>&1'
alias mm='nvim /workspace/tmp/mm_$(date +"%y%m%d_%H%M%S").md'
alias cnt='printf "dirs: %s  symlinks: %s  files: %s\n" "$(fd -IH -t d -d 1 | wc -l)" "$(fd -IH -t l -d 1 | wc -l)" "$(fd -IH -t f -d 1 | wc -l)"'
alias du1='du -ah -d 1 .'
# alias cpwd='pwd | wl-copy -n'
alias update='yay -Syyu'
alias cnt-zh='wl-paste | rg -o -N "\p{Han}" | wc -l'
alias date='LC_TIME=en_GB.UTF-8 date'
alias ipv4='curl -sL4 icanhazip.com'
alias disk='df -hT -x tmpfs -x devtmpfs -x efivarfs'

# base
alias _='sudo'
alias bn='bat -n'
alias bd='bat -d'
alias bp='bat -p'

alias mv='mv -i'
alias cp='cp -i'

alias l='ls -lho --time-style="+%y%m%d %H:%M"'
alias lt='l --sort=time -r'
alias lz='l --sort=size -r'

alias la='ls -lhA --time-style="+%y%m%d %H:%M"'

alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias r='printf "zsh: r command disabled\n"'
alias fc='printf "zsh: fc command disabled\n"'
alias dc='printf "zsh: dc command disabled\n"'
alias as='printf "zsh: as command disabled\n"'

# cd path
alias ,bin='cd ~/.lain/bin'
alias ,Downloads='cd ~/Downloads'
alias ,notes='cd ~/Documents/notes'
alias ,insights='cd ~/Documents/insights'

alias ,dl_tg='cd /data/dl_tg'
alias ,dl_xhs='cd /data/hello/dl_xhs'
alias ,avoid='cd /data/avoid'
alias ,hello='cd /data/hello'
alias ,xhs='cd /data/hello/pending/xhs'
alias ,var='cd /data/hello/pending/var'

alias ,dev='cd /workspace/dev'
alias ,tmp='cd /workspace/tmp'
alias ,yz-dots='cd /workspace/dev/yz-dots'
alias ,raindrop='cd /workspace/dev/raindrop'
alias ,skit='cd /workspace/dev/skit'
alias ,sayhello='cd /workspace/dev/sayhello'

alias ,tidy='cd /workspace/dev/yz-dots/tidy'
