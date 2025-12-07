# todo

- step 过程中, 解决 keymaps 导致 错误 echo KEYMAP=us > /etc/vconsole.conf
- pacman_install 提前指定各个依赖, 尽量防止在执行时提示选择依赖, 在虚拟机测试好, 可以拷贝 /var/log/pacman.log


---


# 注意

> 在后续使用中, 不要再执行 setup 中的脚本了, 里面的脚本都是一次性的, 不要重复执行, 避免出现错误, 因为我懒得维护它的健壮性了, 只允许用其他脚本调用它

> 下次重装需要 先删除 这个 64 GB 的 arch. 然后再装, 不要直接装然后才去删除, 不行
