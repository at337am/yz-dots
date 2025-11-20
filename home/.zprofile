# https://wiki.hypr.land/Useful-Utilities/Systemd-start

if uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi
