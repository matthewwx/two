---
created: 2026-07-15
aliases:
  - 运维平台架构图
tags:
  - 项目
  - 运维
  - 架构图
---

# IT 运维管理平台 — 总体架构

## 一、四层架构总览

```mermaid
graph TD
    subgraph 用户入口
        USER[👤 运维人员]
        NGINX[🌐 Nginx 统一入口<br/>https://运维平台.local]
    end

    subgraph 展示层
        GRAFANA[📊 Grafana<br/>统一仪表盘]
        NOCODB[📋 NocoDB<br/>资产管理]
    end

    subgraph 管理操作层
        COCKPIT[💻 Cockpit<br/>远程管理]
        N8N[🔄 n8n<br/>工作流自动化]
        AUTHENTIK[🔐 Authentik<br/>统一认证]
        VAULT[🔑 Vaultwarden<br/>密码管理]
    end

    subgraph 安全扫描层
        OPENVAS[🛡️ OpenVAS<br/>漏洞扫描]
    end

    subgraph 数据采集层
        LIBRENMS[🔍 LibreNMS<br/>自动发现+网络监控]
        PROMETHEUS[📡 Prometheus<br/>指标采集]
        LOKI[📝 Loki<br/>日志收集]
    end

    subgraph 数据存储
        MINIO[💾 MinIO<br/>备份存储]
        RESTIC[📦 restic<br/>增量备份]
    end

    subgraph 被管理设备
        KALI[🖥️ Kali .177]
        ECSHOP[🖥️ ECShop .168]
        CENTOS[🖥️ CentOS .171]
        DVWA[🐳 DVWA .179<br/>Docker]
    end

    USER --> NGINX
    NGINX --> GRAFANA
    NGINX --> NOCODB
    NGINX --> COCKPIT
    NGINX --> N8N
    NGINX --> OPENVAS
    NGINX --> AUTHENTIK
    
    AUTHENTIK -.统一认证.-> GRAFANA
    AUTHENTIK -.统一认证.-> NOCODB
    AUTHENTIK -.统一认证.-> COCKPIT
    AUTHENTIK -.统一认证.-> N8N

    GRAFANA --> PROMETHEUS
    GRAFANA --> LOKI
    GRAFANA --> LIBRENMS

    PROMETHEUS --> KALI
    PROMETHEUS --> ECSHOP
    PROMETHEUS --> CENTOS
    PROMETHEUS --> DVWA

    LOKI --> KALI
    LOKI --> ECSHOP
    LOKI --> CENTOS

    LIBRENMS --> KALI
    LIBRENMS --> ECSHOP
    LIBRENMS --> CENTOS
    LIBRENMS --> DVWA

    COCKPIT -.远程管理.-> KALI
    COCKPIT -.远程管理.-> ECSHOP
    COCKPIT -.远程管理.-> CENTOS

    N8N -.告警通知.-> DINGTALK[📱 钉钉]
    N8N -.告警通知.-> WECHAT[💬 微信]
    
    RESTIC --> MINIO
    RESTIC -.备份.-> KALI
    RESTIC -.备份.-> CENTOS

    VAULT -.密码管理.-> KALI
    VAULT -.密码管理.-> ECSHOP
    VAULT -.密码管理.-> CENTOS

    OPENVAS -.漏洞扫描.-> KALI
    OPENVAS -.漏洞扫描.-> ECSHOP
    OPENVAS -.漏洞扫描.-> CENTOS
    OPENVAS -.漏洞扫描.-> DVWA
```

---

## 二、部署拓扑

```mermaid
graph LR
    subgraph 管理服务器 .171
        DOCKER[🐳 Docker Engine]
        DOCKER --- L1[LibreNMS :8000]
        DOCKER --- L2[Grafana :3000]
        DOCKER --- L3[Prometheus :9090]
        DOCKER --- L4[NocoDB :8081]
        DOCKER --- L5[n8n :5678]
        DOCKER --- L6[Loki :3100]
        DOCKER --- L7[Vaultwarden :8082]
        DOCKER --- L8[Authentik :9000]
        DOCKER --- L9[MinIO :9001]
        DOCKER --- L10[Nginx :443]
    end

    KALI2[🖥️ Kali .177<br/>node_exporter<br/>snmpd<br/>cockpit<br/>promtail]
    ECSHOP2[🖥️ ECShop .168<br/>node_exporter<br/>snmpd<br/>cockpit<br/>promtail]
    DVWA2[🐳 DVWA .179<br/>node_exporter<br/>snmpd]
    
    DOCKER --- KALI2
    DOCKER --- ECSHOP2
    DOCKER --- DVWA2
```

---

## 三、第一阶段：核心监控拓扑

```mermaid
graph TD
    subgraph 第1周交付
        G1[Grafana 仪表盘]
        subgraph 三大数据源
            L1[LibreNMS<br/>自动发现+网络]
            P1[Prometheus<br/>CPU/内存/磁盘]
            A1[LibreNMS告警<br/>→ 钉钉通知]
        end
    end

    G1 --> L1
    G1 --> P1
    L1 --> A1
    P1 --> A1

    subgraph 被管设备
        D1[.177 Kali<br/>node_exporter + snmpd]
        D2[.168 ECShop<br/>node_exporter + snmpd]
        D3[.171 CentOS<br/>node_exporter + snmpd]
        D4[.179 DVWA<br/>snmpd]
    end

    L1 --> D1
    L1 --> D2
    L1 --> D3
    L1 --> D4
    P1 --> D1
    P1 --> D2
    P1 --> D3
```

---

## 四、告警流向图

```mermaid
flowchart LR
    A[设备异常] --> B{LibreNMS<br/>检测}
    B -->|CPU>90%| C[n8n 自动化]
    B -->|设备离线| D[钉钉通知]
    B -->|磁盘>85%| E[邮件预警]
    B -->|端口不通| F[立即告警]
    
    C --> G{5分钟后?}
    G -->|仍异常| H[SSH 重启服务]
    G -->|已恢复| I[记录日志]
    H --> J[通知结果]
```

---

> 📐 架构图在 Obsidian 中打开即可渲染为图形。已用 Excalidraw MCP 绘制专业版。

## 🎨 Excalidraw 版架构图

![[IT运维平台架构图.excalidraw]]

> 双击上方嵌入图可在 Excalidraw 中编辑。颜色分层：🟢用户入口→🔵展示→🟠管理→🟣采集→🔴存储→⚫设备
