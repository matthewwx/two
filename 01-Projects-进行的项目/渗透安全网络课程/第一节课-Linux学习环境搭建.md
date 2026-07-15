---
created: 2026-07-15
aliases:
  - Linux第一节课
  - Linux学习环境搭建
  - CentOS7安装
tags:
  - Linux
  - 渗透安全
  - 学习笔记
  - CentOS
  - VMware
---

# 第一章 Linux学习环境搭建
本节所讲内容：
1.1 Linux云计算集群架构师课程介绍及Linux发展史
1.2 VMware虚拟机安装
1.3 centos7操作系统安装
1.4 vmware虚拟机12个使用技巧
1.1 Linux发展史
参考同目录下的PPT文档
1.2 VMware虚拟机安装
1.2.1 下载Vmware workstation
下载Vmware workstation含注册码和注册机Centos7.6-ISO 操作系统镜像
通过网盘分享的文件：CentOS-7-x86_64-DVD-1810.iso
链接: https://pan.baidu.com/s/1_pte4yzfG_AL0d_X4mhTCQ 提取码: 22ga 
windows系统，下载VMware workstation
如果是mac系统，下载VMware-Fusion
通过网盘分享的文件：虚拟机软件下载
链接: https://pan.baidu.com/s/18pU4iP5mf8kubpQ4M1Pdjw 提取码: acq7 
--来自百度网盘超级会员v9的分享
1.2.2 安装Vmware workstation
双击安装程序开始安装
![[渗透安全网络课程/附件/Pasted image 20260715210141.png]]
![[渗透安全网络课程/附件/Pasted image 20260715210202.png]]
注：接受许可，下一步。
![[渗透安全网络课程/附件/Pasted image 20260715210309.png]]
![[渗透安全网络课程/附件/Pasted image 20260715210319.png]]
注： 这里把这两个对勾去了，我们这里不检查更新。
![[渗透安全网络课程/附件/Pasted image 20260715210358.png]]
![[渗透安全网络课程/附件/Pasted image 20260715210408.png]]
注：点击安装即可。
![[渗透安全网络课程/附件/Pasted image 20260715210428.png]]
开始安装，等待出现以下界面：
![[渗透安全网络课程/附件/Pasted image 20260715210457.png]]
点击完成即可。
可以看到桌面上已经安装好vmware了。
![[渗透安全网络课程/附件/Pasted image 20260715210527.png]]
鼠标双击这个图标就可以打开VMware开始使用了。
![[渗透安全网络课程/附件/Pasted image 20260715210546.png]]

## 1.2.3 开启虚拟化功能

安装完 VMware 之后，创建 Linux 虚拟机时如果提示「intel vt-x 处于禁用状态」，需要进 BIOS 开启虚拟化。

以 ThinkCentre M4370T 为例：

- 开机按 F1 进入 BIOS
- 进入「高级模式」→「高级菜单」→ 找到「Intel Virtualization 虚拟化技术」
- 将该项改为「Enabled（开启）」
- 按 **F10** 保存退出

> 💡 注意：只要 BIOS 里开启了虚拟化支持就可以，不需要做其他设置。

---

## 1.2.4 安装系统时的分区概念

安装操作系统时，需要给硬盘分区：

| 系统 | 分区方式 |
|------|---------|
| Windows | 通常分 C 盘（系统盘） |
| Linux | 必须有 `/` 根分区（文件系统起始位置），还需要 boot 分区、swap 分区 |

**类比**：Linux 分区像一棵树——
- `/` 是**树根**（根分区）
- boot 是**树干**（启动分区）
- swap 是**树枝**（交换分区，类似 Windows 虚拟内存）
- 其他目录是**树叶**

**LVM（逻辑卷管理）**：支持动态扩容，比如原本 10G 可以扩展到 200G。

### Linux 主流发行版

| 派系 | 代表发行版 | 包管理器 |
|------|-----------|:---:|
| 🎩 RedHat 系 | RHEL、Fedora、CentOS、Rocky、Alma | `yum` |
| 🌀 Debian 系 | Debian、Ubuntu、**Kali** | `apt` |
| 🇨🇳 国产 | 统信 UOS、欧拉、Deepin、麒麟 | — |

---

## 1.2.5 VMware 虚拟机三种网络模式

VMware 提供三种网络模式：

| 模式 | 说明 | IP 要求 |
|------|------|------|
| 🔗 **桥接模式（Bridged）** | 虚拟机当作一台独立主机，直接连物理网络 | IP 与宿主机同一网段，网关/DNS 一致 |
| 🌐 **NAT 模式** | 通过宿主机 NAT 转发上网，虚拟机隐藏在内网 | 设为动态获取 IP（DHCP） |
| 🔒 **仅主机模式（Host-Only）** | 虚拟机只能和宿主机通信，不能上网 | 设为动态获取 IP（DHCP） |

> 💡 企业安装 CentOS 7 时，一般选择 NAT 模式，保证虚拟机可以上网。

---

## 1.3 安装 CentOS 7 操作系统

### 1.3.1 启动 VMware

双击桌面图标，打开 VMware。

### 1.3.2 新建虚拟机

1. 选择「创建新的虚拟机」
2. 选择「自定义（高级）」
3. 虚拟机名称填 `centos7`，存储位置不要放 C 盘（虚拟机文件较大）
4. 处理器：建议 2 核（物理机 4 核的情况下）
5. 内存：建议 2G
6. 网络：选 NAT
7. 磁盘：默认即可

### 1.3.3 挂载 ISO 镜像

安装前选「自定义硬件」→ 双击 **CD/DVD** → 选择「使用 ISO 镜像文件」→ 浏览找到下载的 CentOS 7 ISO → 确定。

> ⚠️ VMware 15 以上版本才能正常识别 64 位操作系统。

### 1.3.4 开启虚拟机，开始安装系统

选择第一项 **Install CentOS 7** 回车：

| 选项 | 含义 |
|------|------|
| Install CentOS 7 | 安装 CentOS 7 |
| Test this media & install CentOS 7 | 先检查安装介质再安装 |
| Troubleshooting | 修复故障（后面修复无法启动的系统时讲） |

### 1.3.5 选择语言

选「中文 - 简体中文」，点击继续。

> 英语不好的同学建议选中文，方便学习。

### 1.3.6 一站式安装配置

在此界面依次配置以下项目：

| 配置项 | 操作 |
|------|------|
| 🕐 **日期和时间** | 选「亚洲/上海」 |
| ⌨️ **键盘** | 默认即可 |
| 📀 **安装源** | 默认光盘即可 |
| 🖥️ **软件选择** | 初学者选「带 GUI 的服务器」，同时勾选「开发工具」相关包 |
| 💾 **安装位置** | 选自动分区 |
| 🔧 **KDUMP** | **关闭**（否则会占用 128MB+ 内存） |
| 🌐 **网络** | **打开以太网连接**，主机名改为 `xuegod63.cn`，IP 从动态改为静态 |

### 1.3.7 设置 Root 密码

Root 密码设为 `123456`（练习用简单密码，点击两次完成确认）。

### 1.3.8 等待安装完成，重启

### 1.3.9 首次登录配置

- 同意许可协议（Licensing）
- 网络连接确认
- GNOME 初始设置：默认，点前进
- 创建普通用户（工作中不直接用 root 登录，安全起见）

### 1.3.10 验证网络

右键桌面空白处 → 打开「终端」：

```bash
[root@localhost ~]# ping www.baidu.com
```

能 ping 通说明网络正常。

### 1.3.11 配置阿里云 YUM 源

CentOS 7 官方源在国外，速度慢。替换为阿里云源：

```bash
# 1. 备份原有 YUM 源
[root@xuegod63 ~]# mv /etc/yum.repos.d/CentOS-Base.repo /opt/

# 2. 下载阿里云 CentOS 7 源
[root@xuegod63 ~]# curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo

# 3. 清理旧缓存，生成新缓存
[root@xuegod63 ~]# yum clean all
[root@xuegod63 ~]# yum makecache
```

### 1.3.12 关闭 SELinux 和防火墙

防止后续实验被拦截：

```bash
# 关闭防火墙（永久+立即生效）
[root@xuegod63 ~]# systemctl disable --now firewalld

# 临时关闭 SELinux
[root@xuegod63 ~]# setenforce 0

# 永久关闭 SELinux
[root@xuegod63 ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

---

## 1.4 VMware 虚拟机 12 个使用技巧

### 技巧 1：虚拟机卡顿 → 增加内存

关闭虚拟机 → 虚拟机设置 → 调大内存。

### 技巧 2：硬件设备添加

虚拟机设置中可以随时添加硬盘、网卡、USB 控制器等。

### 技巧 3：鼠标焦点的切换

光标进入虚拟机后，按 **Ctrl + Alt** 组合键释放光标回宿主机。

### 技巧 4：正确关机

在虚拟机里执行 `init 0` 或 `shutdown`，**不要**直接点 VMware 的 Power OFF（等于非法断电）。

### 技巧 5：发送 Ctrl+Alt+Del

虚拟机里不要按 Ctrl+Alt+Del（会触发宿主机），改用 **Ctrl+Alt+Ins**。

### 技巧 6：显示模式切换

工具栏按钮：窗口模式 / 全屏模式 / 独占模式。

### 技巧 7：三种网络模式

桥接 / NAT / 仅主机（详见 1.2.5）。

### 技巧 8：进入虚拟机 BIOS

虚拟机开机时快速点进虚拟机窗口按 **F2**。

### 技巧 9：安装 VMware Tools

CentOS 7 以后默认已装 open-vm-tools，可直接使用（自适应分辨率、拖拽文件等）。

### 技巧 10：使用 ISO 镜像文件

在虚拟机右下角点击光盘图标 → 设置 → 选择 ISO 文件。

### 技巧 11：删除虚拟机

关闭虚拟机 → 右键虚拟机 → 管理 → 从磁盘中删除。

### 技巧 12：虚拟机快照

拍摄快照 = 保存虚拟机当前状态。出问题可一键恢复到快照点，相当于「时光倒流」。

---

## 本课总结

| 章节 | 内容 |
|------|------|
| 1.1 | Linux 发展史（参考 PPT） |
| 1.2 | VMware 下载安装、虚拟化开启、网络模式（桥接/NAT/仅主机） |
| 1.3 | CentOS 7 完整安装：创建虚拟机 → 安装系统 → 配置 YUM 源 → 关闭 SELinux/防火墙 |
| 1.4 | VMware 12 个实用技巧 |

> 📌 关键命令备忘：
> ```bash
> yum makecache              # 更新 YUM 缓存
> systemctl disable --now firewalld  # 关闭防火墙
> setenforce 0               # 临时关闭 SELinux
> init 0                     # 安全关机
> ```

