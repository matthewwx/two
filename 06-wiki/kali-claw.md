---
created: 2026-07-20
aliases:
  - kali-claw
  - AI渗透代理
tags:
  - 渗透测试
  - AI
  - Kali
  - 工具
  - 安全
source: "https://github.com/brucesongs/kali-claw"
---

# kali-claw — AI 渗透测试智能体

> AI-powered penetration testing agent built on Kali Linux，掌握 518 个安全工具，111 个技能域

---

## 是什么

kali-claw 是一个**预构建的 AI 渗透测试工作空间**，本质是一套 Markdown 格式的知识库 + 配置 + 脚本。不是传统代码仓库，而是让 AI agent 变成"黑客"的**灵魂注入包**。

**核心数据：**
- 111 个安全技能域（100% Excellent+，33 Distinguished）
- 518 个 Kali Linux 工具知识库
- 每个技能含：`SKILL.md`（方法论）+ `payloads.md`（攻击载荷）+ `test-cases.md`（测试用例）+ `guides/`（深度指南）
- 12 条黑客法则

---

## 📦 能跑在什么平台上

| 平台 | 支持 |
|------|------|
| OpenClaw（原生） | ✅ 主平台 |
| **Claude Code** | ✅ 有迁移指南（`GUIDE-CLAUDECODE-zh.md`） |
| Hermes Agent | ✅ |
| OpenAI Codex CLI | ✅ |
| OpenCode | ✅ |

---

## 🔥 和你的关联

| 你已有的 | kali-claw 能补充 |
|----------|-----------------|
| Kali (192.168.3.177) | 直接运行，518 工具全覆盖 |
| Burp Suite | 111 领域远超单一工具 |
| DVWA 靶场 (.179) | 结构化 payload + 测试用例 |
| 挖漏洞路线 | 系统化渗透方法论 |
| OpsBrain (.171) | 漏洞生命周期 + AI 分析 |
| 254 Agents | 专注安全的独立 agent |

---

## 🧠 三种迁移到 Claude Code 的方式

| 方式 | 耗时 | 效果 |
|------|------|------|
| **最小迁移** | 5 分钟 | 直接引用技能文件，Claude Code 原生读取 Markdown |
| **标准迁移** | 30 分钟 | 自定义 Subagent + Rules + Skills 目录 + 记忆系统 |
| **完整迁移** | 2-3 小时 | MCP 集成 + Hooks 自动化 + 编排脚本 + 完整 agent 矩阵 |

> 📌 关键：kali-claw 的技能本质是 Markdown，**Claude Code 原生支持 Agent Skills YAML frontmatter 标准**，无需格式转换！

---

## 🏗️ 111 个技能域速览

```
Web 安全 → SQLi / XSS / CSRF / SSRF / 文件上传 / 反序列化 / SSTI
网络渗透 → 端口扫描 / 服务枚举 / 中间人 / 隧道 / 横向移动
密码攻击 → 暴力破解 / 字典攻击 / 哈希破解 / Kerberoasting
云安全 → AWS / Azure / GCP / K8s 红队
身份安全 → Entra ID / Okta / Auth0 / AD CS (ESC1-15)
AI/LLM → LLM 红队 / AI Agent 安全
供应链 → CI/CD 攻击 / xz-utils / SolarWinds
硬件/嵌入式 → RFID/NFC / 蓝牙 / SCADA/ICS / CAN总线
无线电 → ADS-B / AIS / 卫星 (Starlink/Iridium)
区块链 → L1/L2 / 跨链桥
量子 → 后量子密码攻击
```

---

## 🎯 对你最有价值的部分

1. **Claude Code 迁移指南** — 可以直接绑到二号身上，不需要额外框架
2. **结构化方法论** — 不再是"改 ID 看返回值"，而是每个漏洞有完整的测试流程
3. **payload 库** — SQLi 绕过、XSS 弹窗、SSRF 探测...开箱即用
4. **质量评分体系** — 学习路线有明确的目标和标准

---

## ⚡ 最小迁移（5 分钟体验）

```bash
# 1. 克隆仓库
git clone https://github.com/brucesongs/kali-claw.git ~/kali-claw

# 2. 在 CLAUDE.md 里加一行
# 直接引用技能：
# 参见 ~/kali-claw/skills/web-sqli/SKILL.md

# 3. Claude Code 就能直接读取技能文件了
```

---

## 📚 完整文档

- 使用指南：`GUIDE-OPENCLAW-zh.md`
- Claude Code 迁移：`GUIDE-CLAUDECODE-zh.md`
- 仓库地址：https://github.com/brucesongs/kali-claw

---

## 相关笔记

- [[01-Projects-进行的项目/新人小白自学挖漏洞路线]]
- [[06-wiki/Burp Suite使用教程]]
- [[04-Archives-归档/IT运维管理系统平台/IT运维管理系统平台]]
- [[05-skills-技能管线/kali-burp-mcp-bridge/README]]
