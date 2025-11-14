# 我的Neovim配置

这是基于[LazyVim](https://github.com/LazyVim/LazyVim)框架的个人Neovim配置，定制了多种开发环境和工具集成。

## 主要特性

- **基于LazyVim**：利用LazyVim框架提供的现代化Neovim配置基础
- **多语言支持**：已配置了多种编程语言的支持，包括：
  - Java (jdtls)
  - SQL 和数据库工具 (nvim-dbee)
  - Golang
  - Vue.js
  - PHP
  - MaxCompute

## 插件亮点

- **Git 集成**：
  - Diffview 用于高级差异查看
  - vim-fugitive 用于Git操作
- **Telescope**：强大的模糊查找工具
- **Neo-tree**：文件浏览器
- **代码补全**：
  - 完整的代码补全解决方案
  - GitHub Copilot 集成
- **代码片段**：自定义代码片段支持
- **Markdown 渲染**：增强的Markdown预览功能

## 使用说明

### Java项目设置

```shell
mvn eclipse:clean
mvn eclipse:eclipse
```

## 自定义按键映射

配置了大量自定义键位映射以提高工作效率，详细键位配置请查看 `lua/config/keymaps.lua`。

## 安装

1. 克隆此仓库到您的Neovim配置目录：

```bash
git clone https://github.com/your-username/your-repo.git ~/.config/nvim
```


2. 启动Neovim，LazyVim将自动安装所需插件。

## 更多资源

有关LazyVim的详细信息，请参考[官方文档](https://lazyvim.github.io/installation)。

# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

# sql
# maxcompute
# golang
# java

lsp jdtls  
``` shell
mvn eclipse:clean
mvn eclipse:eclipse
```

```
# vue
# php

cd ~/.local/share/nvim/lazy/LazyVim
