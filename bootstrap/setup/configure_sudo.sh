#!/usr/bin/env bash

# 自定义 /etc/sudoers.d/ 中的配置
# 
# 大多数 Linux 发行版, sudo 默认会清除大部分环境变量, 包括与代理相关的变量, 
# 所以即使你在普通用户环境中设置了代理, sudo pacman 也无法使用它
# 
# 解决方法
#   方法一: 使用 sudo 的 -E 选项来继承当前用户环境变量
#   方法二: 在 /etc/sudoers 文件中允许保留特定变量

set -euo pipefail

