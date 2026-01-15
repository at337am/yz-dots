# ~/.zprofile
#
# I hope your heart is always free.
#
if uwsm check may-start; then
    export LANG=zh_CN.UTF-8
    export LANGUAGE=zh_CN:en_US
    exec uwsm start hyprland.desktop
fi
