---
created: 2026-07-11
aliases:
  - AI知识库教程
  - Obsidian AI教程
status: done
tags:
  - github
  - 备份
  - 教程
---

# 搭建 AI 知识库教程

> 面向零基础，一步步装好，装好就能用。

---

## 一、这套方案是什么？

你需要装 **四个东西**，它们分工明确：

| 装什么 | 它是干什么的 |
|--------|-------------|
| **Obsidian** | 笔记软件，所有笔记存你电脑里 |
| **EchoBird** | 图形化管理 Claude Code 的安装和配置 |
| **Claude Code** | AI 引擎，能读写你的笔记、搜索全库 |
| **Claudian 插件** | 把 Claude Code 嵌入 Obsidian，右侧直接对话 |

装好之后，你在 Obsidian 里写笔记，右侧就能跟 AI 对话。AI 的工作目录就是你的整个知识库，所以它能**读你的任何笔记、帮你写新笔记、搜全库内容**。

> 和普通 AI 插件（Copilot 等）的区别：普通插件只能聊天，Claudian 让 AI 能**直接操作你的文件**。

---

## 二、第一步：安装 Obsidian

### 2.1 下载和安装

1. 打开浏览器，访问 https://obsidian.md
2. 点击首页大大的 **Download**，网站会自动给你对应系统的版本

**Windows**：双击 `.exe`，一路下一步就行。

**Mac**：双击 `.dmg`，把 Obsidian 拖进 Applications 文件夹。如果提示「无法验证开发者」，去系统设置 → 隐私与安全性 → 仍要打开。

### 2.2 创建知识库

1. 打开 Obsidian → 点击 **「创建新库」**
2. 库名称：起个你喜欢的名字
3. 位置：选一个文件夹，**不要放 C 盘**，建议放 D 盘或文档目录
4. 点击创建

> Vault（库）就是一个文件夹。你写的每篇笔记都是这个文件夹里的一个 `.md` 文件。

### 2.3 切换中文

Obsidian 默认是英文。左下角齿轮 ⚙️ → 设置 → About → Language 选 **简体中文** → 点 Relaunch 重启。

---

## 三、第二步：安装 EchoBird 和 Claude Code

**EchoBird** 是个免费的开源工具，帮你在图形界面里管理 Claude Code，不用碰命令行。

### 3.1 安装 EchoBird

**Windows**：按 `Win + R`，输入 `powershell`，粘贴下面命令回车：
```powershell
irm https://echobird.ai/install.ps1 | iex
```

**Mac**：打开终端（`Cmd + 空格` 搜「终端」），粘贴回车：
```bash
curl -fsSL https://echobird.ai/install.sh | sh
```

等待自动完成，桌面会出现 EchoBird 图标。

> 如果命令行不习惯，也可以去 [GitHub Releases](https://github.com/edison7009/EchoBird/releases/latest) 手动下载 `.exe` 或 `.dmg`。

### 3.2 在 EchoBird 里安装 Claude Code

1. 双击打开 EchoBird
2. 进入 **「应用管理」** 页面（左侧导航或主界面）
3. 找到 **「Claude Code」** 的卡片 → 点击 **「安装」**
4. EchoBird 会自动检测环境、下载依赖、完成安装
5. 等进度条跑完 → 卡片变成「已安装」

### 3.3 验证安装

**Windows**：`Win + R` → 输入 `cmd` → 回车后输入：
```
claude --version
```

**Mac**：打开终端，输入：
```
claude --version
```

显示版本号就成功了 ✅

> 如果提示「不是内部或外部命令」，回到 EchoBird 应用管理，点 Claude Code 卡片的 **「修复」**。

---

## 四、第三步：配置 DeepSeek 模型

Claude Code 需要配一个 AI 模型才能工作。选 **DeepSeek**——中文好、便宜、国内访问快。

### 4.1 获取 API Key

1. 打开 https://platform.deepseek.com → 注册登录
2. 左侧菜单 → **API Keys** → 创建 API Key
3. **立刻复制** `sk-xxxxxxxx`，这串密钥只显示一次！

> ⚠️ API Key 相当于你账户的密码，不要发给任何人。

### 4.2 充值

左侧菜单 → 充值 → 建议先充 **10 元**（够日常用几个月）。支持微信和支付宝。

### 4.3 在 EchoBird 中配置

EchoBird 有个 **Model Nexus（模型中心）**——在这里配一次，所有 Agent 共享：

1. EchoBird → **「Model Nexus 模型中心」**
2. 点击 **「添加模型」**

| 填什么 | 填的内容 |
|--------|----------|
| 名称 | `DeepSeek` |
| Base URL | `https://api.deepseek.com/v1` |
| 模型名称 | `deepseek-chat` |
| API Key | 粘贴你的 `sk-xxxx` |

3. 协议类型选 **OpenAI 兼容格式** → 点击保存
4. 点 **「测速」** 验证连接

### 4.4 绑定到 Claude Code

1. 回到 **「应用管理」**
2. 点击 Claude Code 卡片上的模型选择区域 → 选 **DeepSeek**
3. 勾选 **「修改模型配置」**
4. 点击 **「启动」**

### 4.5 验证

在 EchoBird 的对话窗口中输入「你好」，收到 AI 回复就成功了。

> 如果报错，检查：API Key 有没有多余空格、账户是否已充值、Base URL 有没有多一个 `/`。

---

## 五、第四步：安装 Claudian 插件

### 5.1 安装

1. Obsidian → 左下角齿轮 ⚙️ → 设置
2. 左侧 **「第三方插件」** → 点击 **「关闭安全模式」**（确认）
3. 点击 **「浏览」** → 搜索 `Claudian`
4. 安装 → 启用

### 5.2 关键配置

设置 → 第三方插件 → Claudian → 齿轮图标：

| 配置项 | 值 | 说明 |
|--------|-----|------|
| **CLI Path** | claude 的安装路径 | **最重要！不填这个 AI 用不了** |
| Permission Mode | `yolo` | 省去每次确认 |
| User Name | 你的名字 | AI 会这样称呼你 |
| Locale | `zh-CN` | 中文界面 |

### 5.3 怎么找 CLI Path？

**Windows**：`Win + R` → 输入 `cmd` → 输入 `where claude` → 复制输出的路径。

**Mac**：终端输入 `which claude` → 复制。

把路径粘贴到 Claudian 设置的 CLI Path 里，保存。打开右侧对话框，AI 能回复就说明连接成功了 ✅

> 如果不确定路径对不对，直接在 Claudian 对话框里问：「你的 CLI 路径在哪里？」

---

## 六、好不好装不上？

部署过程中最常见的卡点是**网络问题**——下载慢、超时、连不上。

### 6.1 Claude Code 下载慢

提前把 Node.js 和 Claude Code 安装包下载到桌面上，然后在 EchoBird 的 **「安装与修复」** 页面里跟 AI 说：

```
本地安装，读取我放在桌面上的安装包，不要去网上下载
```

AI 会自己找文件，在本地完成安装。

### 6.2 插件市场刷不出来

Obsidian 的插件市场在国内有时候很慢。去 [Claudian GitHub Releases](https://github.com/YishenTu/claudian/releases) 下载 `main.js`、`manifest.json`、`styles.css` 三个文件，手动放到 Vault 的 `.obsidian\plugins\claudian\` 文件夹里，重启 Obsidian 即可。

### 6.3 EchoBird 模型切换不生效

换 **CC Switch** 这个工具代替：打开 → 添加 → 选 DeepSeek → 填 API Key → 一键配置 → 终端输入 `claude` 即可。

> 核心思路：**网络不好就把文件下到本地，让 AI 读本地文件操作。**

---

## 七、搭建知识结构

### 7.1 建文件夹

刚开始不用搞太复杂，**三个文件夹**就够了：

```
📥 Inbox    — 所有新东西先扔这里
📝 Notes    — 整理好的永久笔记
📦 Archive  — 不用的移走
```

在 Obsidian 左侧空白处右键 → 新建文件夹，创建这三个。

### 7.2 一条笔记的一生

```
看到有用的东西 → 丢进 Inbox → 有空时叫 AI 帮你总结整理 → 移到 Notes
```

---

## 八、日常怎么用 AI？

右侧打开 Claudian 对话框，输入下面这些指令就行。

### 8.1 记笔记时

你从网页复制了一篇文章到 Obsidian：

```
总结当前这篇笔记的三个核心要点，写在文件最开头
```

```
根据内容推荐 3-5 个标签，用 [[标签名]] 格式
```

### 8.2 找东西时

不记得某个知识点记在哪了：

```
我关于 Git 分支管理的笔记在哪？帮我搜全库，列出相关笔记
```

### 8.3 整理时

Inbox 里堆了一堆，让 AI 帮你分类：

```
帮我看看 Inbox 里有哪些笔记，给每篇建议移到哪个文件夹
```

### 8.4 建立关联时

```
我刚写了这篇关于 Docker 的笔记，搜全库有哪些笔记跟它相关，帮我加上 [[双向链接]]
```

---

## 九、让 AI 更懂你

在你的 Vault 根目录下新建一个 `CLAUDE.md` 文件，Claude Code 每次启动都会读它。

```markdown
# 我的知识库

## 文件夹
- Inbox/ — 待整理
- Notes/ — 永久笔记
- Archive/ — 归档

## 规则
- 修改文件前先确认
- 新笔记用中文文件名
- 标签用 [[标签名]] 格式
- 搜索时优先搜文件名和标题
```

> 随着你用得越来越多，随时往里加新的规则。

---

## 十、常见问题

**Q：API 费用贵吗？**

DeepSeek 充 10 块，日常使用能用 2-3 个月。一条提问才几分钱。

**Q：AI 会乱改我的笔记吗？**

Claudian 设置里把 Permission Mode 改成 `acceptEdits`，AI 修改文件前会问你是否同意。

**Q：我的数据安全吗？**

所有笔记存在你电脑本地。只有你主动发给 AI 的内容会传到 DeepSeek 的服务器。敏感信息不要发给 AI。

**Q：不同设备怎么同步？**

把 Vault 文件夹放在 OneDrive 或 iCloud 目录下。或者装 Obsidian Git 插件用 Git 同步。

---

## 十一、总结

记住三步就够了：

1. **装好** — Obsidian + EchoBird + Claude Code + DeepSeek + Claudian，半小时搞定
2. **用起来** — 想到什么就记，让 AI 帮你总结、搜索、整理
3. **慢慢养** — 每周花 10 分钟让 AI 帮你回顾和清理

不需要完美的体系，先跑通「记 → AI 加工 → 归档」这条链路就行。
