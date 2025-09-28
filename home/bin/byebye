#!/usr/bin/env bash

countdown=3

# 提示用户程序即将关闭
printf "Time to bid farewell to running apps...\n"

pkill -9 obsidian
pkill -15 Telegram
pkill -15 nekoray

# 脚本执行完成后, 通知用户所有程序已关闭
# 倒计时开始, 并提示可通过 Ctrl+C 取消关机
printf "All clear! Apps have left the building.\n"
printf "Going dark in %d seconds. Press Ctrl+C to stay alive.\n" "$countdown"

# 逐秒倒计时显示剩余时间, 允许用户中断操作
for i in $(seq "$countdown" -1 1); do
    printf "\rT-minus %d seconds... Ctrl+C to cancel." "$i"
    sleep 1
done

printf "\nLights out! Dream of code and bugs.\n"

sudo shutdown -h now
