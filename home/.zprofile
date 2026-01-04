set_env() {
    # 语言设置
    export LANG=zh_CN.UTF-8
    export LANGUAGE=zh_CN:en_US

    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway

    # Electron/Chromium Wayland 支持
    export ELECTRON_OZONE_PLATFORM_HINT=wayland
    export OZONE_PLATFORM=wayland

    export MOZ_ENABLE_WAYLAND=1

    # QT 设置
    export QT_QPA_PLATFORM="wayland;xcb"
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_QPA_PLATFORMTHEME=qt6ct
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # original 1.0
    export QT_SCALE_FACTOR=1.25

    # GTK 设置
    export GTK_USE_PORTAL=1

    # 代理设置
    export http_proxy=http://127.0.0.1:2080
    export https_proxy=http://127.0.0.1:2080
    export no_proxy="localhost,127.0.0.1,192.168.0.0/16,*.local"
    export HTTP_PROXY=http://127.0.0.1:2080
    export HTTPS_PROXY=http://127.0.0.1:2080
    export NO_PROXY="localhost,127.0.0.1,192.168.0.0/16,*.local"

    # 鼠标样式
    export XCURSOR_THEME=Breeze_Light
    export XCURSOR_SIZE=30

    # 输入法环境
    export XMODIFIERS=@im=fcitx5
    export QT_IM_MODULE=fcitx5
}

if [[ -z "$DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
    set_env
    exec sway > ~/.cache/sway.log 2>&1
fi
