---
created: 2026-07-14
aliases:
  - DVWA
  - DVWA搭建
  - 靶场搭建
tags:
  - 安全
  - 渗透测试
  - DVWA
  - 靶场
  - 教程
---

# DVWA 靶场搭建文档

> DVWA（Damn Vulnerable Web Application）— 故意设计得漏洞百出的 PHP/MySQL Web 应用，新手练手神器

---

## 一、DVWA 简介

| 项目 | 说明 |
|------|------|
| 全称 | Damn Vulnerable Web Application |
| 语言 | PHP + MySQL |
| 漏洞覆盖 | SQL注入、XSS、CSRF、文件上传、命令注入、文件包含等 OWASP Top 10 |
| 安全等级 | Low → Medium → High → Impossible（四级） |
| 默认账号 | admin / password |

---

## 二、搭建方式对比

| 方式 | 速度 | 难度 | 适用场景 |
|------|------|------|----------|
| **Docker** ⭐ | 3 分钟 | 极低 | 推荐！一行命令搞定 |
| PHPStudy | 10 分钟 | 低 | Windows 本地 |
| XAMPP | 15 分钟 | 中 | 跨平台 |
| 手动 LAMP | 30 分钟 | 高 | 学习环境搭建过程 |

---

## 三、Docker 部署（推荐）

### 3.1 安装 Docker（CentOS 7）

```bash
# 安装依赖
yum install -y yum-utils

# 添加阿里云 Docker 源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装
yum install -y docker-ce docker-ce-cli containerd.io

# 启动 + 开机自启
systemctl start docker
systemctl enable docker
docker --version
```

### 3.2 配置国内镜像加速

```bash
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": [
    "https://dockerproxy.com",
    "https://hub-mirror.c.163.com"
  ]
}
EOF
systemctl daemon-reload && systemctl restart docker
```

### 3.3 拉取并启动 DVWA

```bash
# CentOS 7 必须加 --privileged，否则 MySQL 启动失败
docker run -d \
  --name dvwa \
  -p 8080:80 \
  --privileged \
  --cap-add=SYS_ADMIN \
  --restart always \
  vulnerables/web-dvwa
```

### 3.4 初始化

1. 浏览器访问 `http://服务器IP:8080`
2. 点击底部 **Create / Reset Database**
3. 看到 "Database setup complete!" → 成功
4. 登录：**admin / password**

### 3.5 常用管理命令

| 操作 | 命令 |
|------|------|
| 启动 | `docker start dvwa` |
| 停止 | `docker stop dvwa` |
| 重启 | `docker restart dvwa` |
| 查看日志 | `docker logs -f dvwa` |
| 进入容器 | `docker exec -it dvwa /bin/bash` |
| 删除重建 | `docker stop dvwa && docker rm dvwa` |

---

## 四、PHPStudy 部署（Windows 本地）

### 4.1 安装 PHPStudy

1. 下载：https://www.xp.cn/
2. 安装后启动 **Apache + MySQL**

### 4.2 部署 DVWA

```bash
# 下载 DVWA 源码
git clone https://github.com/digininja/DVWA.git

# 放入 PHPStudy 网站目录
# 例如：C:\phpstudy_pro\WWW\dvwa\
```

### 4.3 配置

进入 `dvwa/config/`，复制配置文件：
```
config.inc.php.dist → config.inc.php
```

修改数据库配置：
```php
$_DVWA['db_user'] = 'root';
$_DVWA['db_password'] = 'root';  // PHPStudy 默认密码
$_DVWA['db_database'] = 'dvwa';
```

### 4.4 初始化

1. 访问 `http://127.0.0.1/dvwa/setup.php`
2. 点 **Create/Reset Database**
3. 登录：admin / password

---

## 五、初始化后必做：调整安全等级

登录后 → 左侧菜单 **DVWA Security** → 选择难度 → Submit

| 等级 | 说明 | 建议 |
|------|------|------|
| **Low** | 几乎无防护 | ⭐ 从这里开始 |
| **Medium** | 有基础过滤 | Low 通关后尝试 |
| **High** | 严格防护 | 进阶练习 |
| **Impossible** | 安全代码范例 | 学习防御写法 |

---

## 六、常见问题

| 问题 | 解决 |
|------|------|
| MySQL 启动失败 | CentOS 加 `--privileged` 参数 |
| 远程无法访问 | 关防火墙：`systemctl stop firewalld` |
| 端口被占用 | 换端口：`-p 8081:80` |
| reCAPTCHA 报错 | 注释 config.inc.php 里 reCAPTCHA 配置 |
| 命令注入不生效 | php.ini 删掉 `disable_functions` 中的 `shell_exec` |
| 文件包含不生效 | php.ini 设 `allow_url_include = On` |

---

## 七、当前部署信息 ✅

| 项目 | 详情 |
|------|------|
| **访问地址** | `http://192.168.3.179:8081` |
| **主机** | 192.168.3.179 — CentOS 7（VMware） |
| **部署方式** | Docker |
| **镜像** | `vulnerables/web-dvwa:latest` |
| **Docker 镜像源** | `docker.1ms.run`（国内加速） |
| **默认账号** | admin / password |
| **部署时间** | 2026-07-14 |

### 管理命令

```bash
# 停止
ssh root@192.168.3.179 "docker stop dvwa"

# 启动
ssh root@192.168.3.179 "docker start dvwa"

# 重启
ssh root@192.168.3.179 "docker restart dvwa"

# 查看状态
ssh root@192.168.3.179 "docker ps | grep dvwa"
```

### 局域网靶场一览

| IP | 用途 | 访问地址 |
|----|------|----------|
| **192.168.3.179** | 🎯 DVWA 靶场 | `http://192.168.3.179:8081` |
| **192.168.3.168** | 🛒 ECShop 商城 | `http://192.168.3.168` |
| **192.168.3.177** | 🐉 Kali 攻击机 | — |
| **192.168.3.171** | 🖥️ CentOS 7 备用 | — |

---

## 八、练手顺序

1. 登录 DVWA → 设为 Low
2. 打开 Burp Suite 挂代理
3. 从 **SQL Injection** 开始（最简单的漏洞）
4. 逐个模块通关：SQL注入 → XSS → CSRF → 文件上传 → 命令注入
5. 提高到 Medium → 再通一遍

---

相关笔记：
- [[06-wiki/Burp Suite使用教程]]
- [[01-Projects-进行的项目/新人小白自学挖漏洞路线]]
- [[01-Projects-进行的项目/安全渗透]]
