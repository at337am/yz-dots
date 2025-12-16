#!/bin/bash

echo "=== 开始清理 Arch Linux 系统 ==="

# 解释: -Yc 是 yay 清理不需要的依赖的命令
echo "-> 正在检查并移除孤儿依赖..."
yay -Yc --noconfirm

# 2. 清理 Pacman 缓存 (官方仓库)
# 推荐: 使用 paccache 保留最近的 2 个版本，删除更旧的。
# 这样如果新版挂了，你还有上一个版本可以回退。
if command -v paccache &> /dev/null; then
    echo "-> 正在清理 Pacman 缓存 (保留最近2个版本)..."
    sudo paccache -r -k 2
    # 可选: 清理已被卸载软件的缓存
    sudo paccache -ruk0
else
    echo "警告: 未找到 paccache 命令。建议安装 'pacman-contrib'。"
    echo "-> 执行保守清理 (只删除未安装包的缓存)..."
    sudo pacman -Sc --noconfirm
fi

# 3. 清理 Yay/AUR 缓存
# 解释: yay 的缓存通常在 ~/.cache/yay
echo "-> 正在清理 Yay (AUR) 缓存..."
# 仅保留已安装包的缓存，并询问是否清理构建目录
# --noconfirm 会自动回答 yes，如果你想手动确认请去掉
yay -Sc --noconfirm

# 4. (可选) 清理用户主目录下的缓存
# 很多软件会在 ~/.cache 留下垃圾，可以使用 rm -rf ~/.cache/* 
# 但这太激进，可能导致某些程序图标丢失或重置，不建议写入自动脚本。

echo "=== 清理完成！ ==="
echo "当前磁盘空间使用情况:"
df -h /