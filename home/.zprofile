# Autostart Hyprland on TTY1 login
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec dbus-run-session Hyprland
fi
