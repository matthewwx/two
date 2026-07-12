---
created: 2026-07-11
aliases:
  - burpsuite教程
  - bp教程
  - 抓包工具
tags:
  - 安全
  - 渗透测试
  - BurpSuite
  - 工具
  - 教程
---

# Burp Suite 使用教程

> 挖漏洞最重要的工具，没有之一。只讲实战用得上的部分。

## 视频教程推荐

| 序号  | 视频                                                               | 播放量   | 时长   | 建议       |
| --- | ---------------------------------------------------------------- | ----- | ---- | -------- |
| 🥇  | [抓包爆破学得好，牢饭吃到饱](https://www.bilibili.com/video/BV1YSpszvEvE/)    | 12.5万 | 37h  | 系统学，当字典查 |
| 🥈  | [BurpSuite零基础入门教程](https://www.bilibili.com/video/BV1kLHkzZEen/) | 7.7万  | 61h  | 最全面体系    |
| 🥉  | [BurpSuite零基础入门全4集](https://www.bilibili.com/video/BV1bAvPz8EKE/) | 4.7万  | 1.5h | ⭐ 快速上手首选 |

> 💡 **建议先看 🥉 1.5 小时快速版**，掌握核心操作后直接去实战，遇到问题翻 🥇 当参考。

---

## 一、启动 Burp Suite

```
Kali 终端输入：burpsuite
```

- 选 **Temporary Project**（临时项目）
- 点 **Use Burp Defaults**
- 点 **Start Burp**

---

## 二、配置浏览器代理（让流量经过 Burp）

Burp Suite 默认监听 **127.0.0.1:8080**

### Kali 自带 Firefox 配置

1. Firefox → 右上角三横 → **Settings**
2. 搜 **proxy** → 点 **Settings...**
3. 选 **Manual proxy configuration**
4. HTTP Proxy：`127.0.0.1` 端口 `8080`
5. 勾选 **Also use this proxy for HTTPS**
6. 点 OK

> 💡 **推荐装 FoxyProxy 插件**，一键切换代理开关，比手动改方便。

---

## 三、安装 HTTPS 证书（不装没法抓 HTTPS）

1. 浏览器代理配好后，访问 `http://burpsuite`
2. 点右上角 **CA Certificate** 下载证书
3. Firefox → Settings → 搜 **certificates** → **View Certificates**
4. **Authorities** 标签 → **Import** → 选刚下载的证书
5. 勾选 **Trust this CA to identify websites** → OK

---

## 四、核心功能详解

### 4.1 Proxy（拦截）—— 抓包看请求

这是入口，流量先进这里。

| 按钮 | 作用 |
|------|------|
| **Intercept is on** | 拦截所有请求，可修改后再放行 |
| **Forward** | 放行当前请求 |
| **Drop** | 丢弃当前请求 |
| **Intercept is off** | 不拦截，流量直接过 |

**新手最常用模式：**
- 平时把 Intercept 关掉（off）
- 需要改参数时打开（on）
- 改完 Forward 放行

### 4.2 HTTP History（历史记录）—— 回头看所有请求

Proxy → **HTTP history** 标签。

- 浏览器所有请求都在这
- 右键某条 → **Send to Repeater**（最常用操作）

### 4.3 Repeater（重放）—— ⭐ 最核心功能

把请求发到 Repeater，反复修改参数、反复发送、看返回。

**操作流程：**
```
Proxy/HTTP History → 右键 → Send to Repeater
→ 切到 Repeater 标签
→ 改参数 → 点 Go → 看 Response
```

**示例：测越权漏洞**
```
原始请求：GET /api/user/info?id=100
改成：    GET /api/user/info?id=101
点 Go → Response 里出现了别人的数据 → 漏洞！
```

### 4.4 Intruder（爆破）—— 批量遍历参数

用于遍历 ID、爆破验证码。

**操作流程：**
1. 请求 → Send to Intruder
2. 选中要遍历的参数值 → 点 **Add §**
3. Attack type 选 **Sniper**
4. Payloads 标签 → 选 **Numbers**（或自定义列表）
5. 点 **Start attack**
6. 看 Response 长度 → 长度不同的那条就是异常

**示例：遍历用户 ID**
```
GET /api/user/info?id=§1§
Payload: Numbers, 1-100
Start → 谁的返回长度不一样，谁的数据就被你看到了
```

### 4.5 Decoder（编解码）

- URL 编码/解码
- Base64 编码/解码
- Hex、Unicode 转换

---

## 五、实战练习流程（跟着做一遍）

```
1. 开启 Burp，配好代理，Intercept 关掉（off）

2. 随便打开一个网站登录

3. 切回 Burp → Proxy → HTTP history
   → 找刚才访问的请求
   
4. 找到一条带参数的请求（比如 /user/info?id=xxx）
   → 右键 → Send to Repeater

5. 切到 Repeater 标签
   → 改 id 的值 → 点 Go → 看返回了什么

6. 熟悉了之后试试 Intruder 批量遍历
```

---

## 六、推荐插件

### 安装方法

| 方式 | 步骤 |
|------|------|
| **BApp Store 在线安装（推荐）** | `Extender` → `BApp Store` → 搜索插件名 → `Install` |
| **手动安装 .jar** | `Extender` → `Extensions` → `Add` → 选择 .jar 文件 |

### ⭐⭐⭐ 第一梯队（新手必装）

| 插件                 | 功能                                              | 来源                                                                               |
| ------------------ | ----------------------------------------------- | -------------------------------------------------------------------------------- |
| Logger++           | 全流量记录，高级过滤/正则搜索/导出，比原生 History 好用得多             | [BApp Store](https://portswigger.net/bappstore/745f9e3c8a5f4d17b56f47a0c3b3b5f9) |
| HaE                | 自动高亮+提取敏感信息（手机号、邮箱、Token、API Key），一眼看出异常        | [BApp Store](https://github.com/gh0stkey/HaE)                                    |
| **Autorize** | ⭐ 自动越权检测！用低权限 Cookie 重放高权限请求，红色 "Bypassed!" 即越权 | [手动安装](https://github.com/Quitten/Autorize.git) |
| **Turbo Intruder** | 高速爆破引擎，比原生 Intruder 快几十倍                        | BApp Store                                                                       |
|                    |                                                 |                                                                                  |

### ⭐⭐ 第二梯队（进阶推荐）

| 插件                | 功能                |
| ----------------- | ----------------- |
| **JWT Editor**    | 可视化 JWT 解码/修改/攻击  |
| **Param Miner**   | 自动挖掘隐藏参数          |
| **Hackvertor**    | 100+ 种编码转换，嵌套标签语法 |
| **Auth Analyzer** | 自动化认证/授权漏洞检测      |

### Autorize 安装特别说明

Autorize 是 Python 插件，需要先装 Jython 环境：

1. 去 [Jython 官网](https://www.jython.org/download) 下载 `jython-installer-2.7.4.jar`
2. 运行安装（一路 Next）
3. Burp → **Extender → Options → Python Environment** → **Select File** → 选择 Jython 安装目录下的 `jython.jar`
4. 再从 BApp Store 安装 Autorize

> ⚠️ BApp Store 安装需要科学上网，如果连不上，手动下载：
>
> git clone https://github.com/Quitten/Autorize.git
> ```
> 然后 `Extender → Extensions → Add` → 选择 `Autorize.py`

### HaE 配置要点

1. 安装后出现 **HaE** 标签页
2. 首次加载会自动拉取官方规则库（`Rules.yml`）
3. 规则文件路径：`%USERPROFILE%/.config/HaE/`
4. 在 **Scope** 中指定生效模块（建议全选 Proxy + Repeater）
5. 在 **Databoard** 查看匹配结果，按域名/规则类型筛选

### Logger++ 配置要点

1. 安装后自动记录所有流量
2. 在 **Options** 中设置记录哪些模块（建议全选）
3. 设置高亮规则：按状态码 200/403、敏感关键词自动标记
4. 支持导出 CSV/JSON 用于离线分析

> ⚠️ 插件不要装太多，按需启用，不常用的点 `Unload`，避免 Burp 卡顿

> 💡 **新手最小组合**：Autorize + HaE + Logger++ 三件套就够用了

---

## 七、常见问题

| 问题 | 解决 |
|------|------|
| 开了代理浏览器上不了网 | 检查 Burp 是不是关了，关掉代理或重启 Burp |
| HTTPS 网站提示不安全 | 证书没装好，重装 CA 证书 |
| 抓不到 localhost 的包 | Firefox 默认不代理 localhost，用 `http://127.0.0.1` 或装 FoxyProxy |

---

## 下一步

学完 Burp Suite 基础操作后，去 [[01-Projects-进行的项目/新人小白自学挖漏洞路线]] 看第四阶段「漏洞挖掘核心思路」，开始实战！

---

相关笔记：
- [[06-wiki/安全工具高频英语词汇]] — 📖 看不懂英文菜单？每天 5 个词
- [[01-Projects-进行的项目/新人小白自学挖漏洞路线]]
