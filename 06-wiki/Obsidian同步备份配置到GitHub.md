---
created: 2026-07-11
aliases:
  - GitHub备份
  - Git同步
tags:
  - git
  - github
  - 备份
  - 教程
status: done
---

# GitHub 备份同步配置指南

把 Obsidian 知识库备份到 GitHub 的完整流程。

## 一、初始化本地 Git 仓库

在 Vault 根目录下创建 `.gitignore`，排除不需要备份的文件：

```
# Obsidian workspace（个人布局，频繁变动）
.obsidian/workspace.json

# 临时文件
.temp_video_frames/
tempvf/

# Claude 本地配置
.claude/
.claudian/
```

然后初始化仓库并首次提交：

```bash
git init
git config user.name "你的GitHub用户名"
git config user.email "你的邮箱"
git add -A
git commit -m "初始化备份"
```

## 二、在 GitHub 创建远程仓库

1. 打开 https://github.com/new
2. **Repository name** 填仓库名（中文会自动转拼音）
3. 选 **Private**（私密）
4. **不要勾选**任何初始化选项
5. 点 **Create repository**

## 三、配置 SSH 密钥（推荐，一劳永逸）

HTTPS 直连可能被墙，SSH 更稳定且免密。

### 3.1 生成密钥

```bash
ssh-keygen -t ed25519 -C "你的邮箱@example.com" -N "" -f ~/.ssh/id_ed25519
```

### 3.2 添加公钥到 GitHub

```bash
cat ~/.ssh/id_ed25519.pub
```

复制输出内容 → 打开 https://github.com/settings/keys → **New SSH key** → 粘贴 → Add SSH key

### 3.3 关联远程仓库并推送

```bash
git remote add origin git@github.com:用户名/仓库名.git
git branch -M master
git push -u origin master
```

## 四、日常备份

以后需要备份时，在 Vault 根目录执行：

```bash
git add -A
git commit -m "备份：日期说明"
git push
```

也可以使用 Obsidian Git 插件自动定时备份。

---

## 二号大脑配置记录

| 项目 | 值 |
|------|-----|
| 本地 Vault 路径 | `F:\obsidian\二号大脑` |
| GitHub 用户 | `matthewwx` |
| GitHub 仓库 | `matthewwx/two` |
| SSH 密钥 | `~/.ssh/id_ed25519` |
| Git 用户 | `matthewwx` |
| Git 邮箱 | `wangmatthew@163.com` |
