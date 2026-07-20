---
created: 2026-07-16
aliases:
  - OpsBrain 开发日志
  - 运维平台开发
tags:
  - 项目
  - 运维
  - 开发
  - FastAPI
  - Vue3
---

# IT运维管理系统平台 — 开发日志

> 基于 [[IT运维管理系统平台]] 的架构设计，用 Python FastAPI + Vue 3 实现的统一管理门户。

## 项目概述

**定位**：胶水层 + 补缺。底层开源工具继续用（LibreNMS、Prometheus、Grafana、NocoDB、n8n 等），自研只做聚合 + 填补开源工具不好覆盖的空白。

**核心自研模块**：
- ⭐ 漏洞生命周期管理（状态机 + 审计日志）
- ⭐ 任务工单系统
- ⭐ 知识库（Markdown 文档管理）
- ⭐ 操作审计日志

## 技术栈

| 层 | 选型 | 版本 |
|---|---|---|
| 后端框架 | FastAPI | 0.139 |
| ORM | SQLModel | 0.0.39 |
| 数据库 | SQLite（可切 PostgreSQL） | - |
| 认证 | HTTPOnly Cookie + JWT | python-jose 3.5 |
| 前端框架 | Vue 3 + Vite | 3.5 / 6.x |
| UI 组件库 | Element Plus | 2.9 |
| 图表 | ECharts | 5.5 |

## 部署信息

| 项目 | 值 |
|------|-----|
| 服务器 | 192.168.3.171（CentOS 7.6） |
| 部署路径 | `/opt/opsbrain/` |
| Python | 3.10.13（源码编译） |
| OpenSSL | 1.1.1w（源码编译） |
| 服务管理 | systemd（`opsbrain.service`） |
| 访问地址 | http://192.168.3.171:8000 |
| Swagger | http://192.168.3.171:8000/docs |

## 项目结构

```
OpsBrain/                     # 代码仓库（F:\obsidian\OpsBrain）
├── backend/
│   ├── app/
│   │   ├── main.py           # FastAPI 入口 + 生命周期 + 前端托管
│   │   ├── config.py         # 全局配置（工具地址等）
│   │   ├── database.py       # SQLModel 引擎 + session
│   │   ├── models/           # 9 张数据表
│   │   │   ├── user.py       # RBAC（User/Role/Permission + M2M）
│   │   │   ├── vulnerability.py  # 漏洞 + 审计日志
│   │   │   ├── task.py       # 工单 + 评论
│   │   │   ├── knowledge.py  # 知识库分类 + 文章
│   │   │   └── audit.py      # 操作审计
│   │   ├── schemas/          # Pydantic 请求/响应
│   │   ├── api/              # 8 个路由模块
│   │   ├── services/         # 业务逻辑层
│   │   ├── middleware/       # 认证 + 审记中间件
│   │   └── utils/            # 安全 + 响应工具
│   ├── requirements.txt
│   └── run.py
├── frontend/
│   ├── src/
│   │   ├── views/            # 10 个页面组件
│   │   ├── router/           # Vue Router + 路由守卫
│   │   ├── stores/           # Pinia 状态管理
│   │   ├── api/              # Axios 封装
│   │   ├── components/
│   │   └── layouts/          # MainLayout（侧边栏+顶栏）
│   ├── package.json
│   └── vite.config.ts
├── deploy/
│   ├── deploy.sh             # 一键部署脚本
│   └── opsbrain.service      # systemd 服务文件
└── scripts/
    └── seed_data.py          # 测试数据注入脚本
```

## 数据库表（9 张）

### RBAC（5 张）
- `users` — 用户
- `roles` — 角色（admin/operator/viewer）
- `permissions` — 权限（15 个）
- `user_roles` — 用户-角色 M2M
- `role_permissions` — 角色-权限 M2M

### 业务表（4 张）
- `vulnerabilities` — 漏洞生命周期
- `vulnerability_logs` — 漏洞审计日志（不可变）
- `tasks` + `task_comments` — 任务工单 + 评论
- `kb_categories` + `kb_articles` — 知识库分类树 + 文章
- `audit_logs` — 全局操作审计

## API 端点（30+）

| 模块 | 端点 | 说明 |
|------|------|------|
| 认证 | `/api/auth/login` / `logout` / `refresh` / `me` | JWT 双 token |
| 仪表盘 | `/api/dashboard/stats` / `severity-chart` / `task-status-chart` / `grafana-panels` | 统计 + 图表 |
| 漏洞 | `/api/vulnerabilities` CRUD + `/status` + `/stats` + `/import/openvas` | ⭐ 核心 |
| 工单 | `/api/tasks` CRUD + `/comments` | 待办管理 |
| 知识库 | `/api/knowledge/articles` + `/categories` | Markdown 文档 |
| 资产 | `/api/assets` | 代理 NocoDB |
| 告警 | `/api/alerts` | 聚合 Prometheus |
| 工具 | `/api/tools` + `/tools/health` | 8 工具状态 |

## 漏洞状态机

```
discovered → confirmed → in_progress → fixed → verified
          ↘ false_positive / accepted_risk
fixed → reopened → in_progress
```

每次状态变更自动写入 `vulnerability_logs`（不可变审计追踪）。

## 部署命令

```bash
# 从本机部署
cd F:/obsidian/OpsBrain
bash deploy/deploy.sh 192.168.3.171

# 手动重启
ssh root@192.168.3.171 systemctl restart opsbrain
ssh root@192.168.3.171 journalctl -u opsbrain -f
```

## 默认账号

```
用户名: admin
密码:   admin123
角色:   超级管理员（is_superuser，绕过所有权限检查）
```

## 已知问题 / 待完善

- [ ] NocoDB 未部署 — 资产管理页暂无数据
- [ ] Grafana 未部署 — 仪表盘 Grafana 面板显示"未连接"
- [ ] 171 防火墙未配 Nginx — 目前直接暴露 8000 端口
- [ ] 前端 chunk 较大 — Dashboard/ElementPlus 可做 code split
- [ ] SQLite → PostgreSQL 迁移（生产环境）

## 相关笔记

- [[IT运维管理系统平台]] — 底层架构设计
- [[IT运维管理系统平台五层架构图]] — 架构图
- [[安全工具高频英语词汇]] — 英语学习

---

---

## P0/P1/P2 增强功能（2026-07-17）

### P0 — 核心增强
| 功能 | 来源 | 状态 | 说明 |
|------|------|------|------|
| 🤖 AI 漏洞分析 | Vul-Manager | ✅ | 调用 DeepSeek API 自动评估漏洞风险，结果写入审计日志 |
| 🎯 nmap 自动发现 | veops/cmdb | ✅ | 扫描局域网设备，一键导入资产库 |

### P1 — 重要增强
| 功能 | 来源 | 状态 | 说明 |
|------|------|------|------|
| 🔧 代码生成器 | 若依 | ✅ | `python scripts/codegen.py ModelName` 一键生成 CRUD 四件套 |
| 📊 服务监控 | 若依 | ✅ | CPU/内存/磁盘/网络实时监控，仪表盘可视化 |
| 💻 Web SSH | open-cmdb | ✅ | WebSocket SSH 代理（需 `pip install asyncssh`） |

### P2 — 后续
- ⏳ Radar 监控面板（API 请求/SQL 性能实时监控）
- ⏳ 网络拓扑可视化
- ⏳ Excel 拖拽导入漏洞

---

## 资产管理与用户管理（2026-07-17）

### 资产管理
- ✅ MAC 地址字段
- ✅ 编辑功能（完整表单）
- ✅ ARP 扫描 + nmap 发现（两种方式）
- ✅ 5 台内网设备已录入（含 MAC 地址）

### 用户管理
- ✅ 用户 CRUD + 角色分配
- ✅ 3 个角色：管理员 / 运维工程师 / 只读用户
- ✅ 15 个细粒度权限
- ✅ 默认用户：admin(超管) / operator1 / viewer1

---

## Docker 工具栈部署（2026-07-17）

### 🟢 已部署（5 个容器 + OpsBrain）

| 工具 | 端口 | 账号 | 内存 |
|------|------|------|------|
| OpsBrain | 8000 | admin/admin123 | ~60MB |
| Prometheus | 9090 | 免登录 | ~44MB |
| Grafana | 3000 | admin/admin123 | ~181MB |
| n8n | 5678 | admin/admin123 | ~139MB |
| Loki | 3100 | API | ~69MB |
| Vaultwarden | 8082 | 首次注册 | ~21MB |

### 🔴 未部署
- **NocoDB** — CentOS 7 Docker 文件系统/SELinux 兼容问题，功能已由 OpsBrain 内置 CMDB 替代
- **LibreNMS** — 端口 8000 冲突（OpsBrain 占用），nmap 扫描已替代网络发现功能
- **OpenVAS** — 需 4GB+ 内存，171 仅 2GB，待升级硬件

### 联动关系
```
Prometheus → Grafana (数据源已自动配置)
Loki → Grafana (数据源已自动配置)
OpsBrain → Prometheus (监控目标已添加)
OpsBrain → 全部工具 (TCP 健康检测)
```

### Docker 运维
```bash
ssh root@192.168.3.171
cd /opt/opsbrain/docker
docker compose ps          # 查看状态
docker compose restart     # 重启全部
```

---

## 服务器最终状态

```
192.168.3.171 (CentOS 7.6, xuegod63.cn)
├── 内存: 731M / 1.9G (可用 996M)
├── 磁盘: 8.3G / 50G (剩余 42G)
├── 5 个 Docker 容器 (Prometheus/Grafana/n8n/Loki/Vaultwarden)
├── 1 个 FastAPI 服务 (OpsBrain, systemd 自启)
├── Python 3.10.13 + OpenSSL 1.1.1w (源码编译)
├── SSH 免密登录 (从 Kali 和本机)
└── 防火墙: 8000,9090,3000,5678,3100,8082 已开放
```

---

## 7/16 同类型开源项目对比

详见 [[同类开源项目对比分析]]

**结论：不替换。OpsBrain 是唯一同时覆盖「漏洞+工单+知识库+CMDB+监控集成」的平台。**

最值得借鉴的功能已按优先级实现：
- P0: AI 漏洞分析 + nmap 发现 ✅
- P1: 代码生成器 + 服务监控 + Web SSH ✅
- P2: Radar 面板 + 网络拓扑 + Excel 导入 ⏳

---

> 📅 开发日期：2026-07-16 ~ 2026-07-17
> 👤 开发方式：一号设计 + 二号（Claudian）编码 + 一键部署到 171
> 🔗 架构设计：[[IT运维管理系统平台]]
> 🔗 竞品分析：[[同类开源项目对比分析]]

