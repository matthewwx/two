---
created: 2026-07-20
aliases:
  - Linux第四节课
  - Vim编辑器
  - Xshell
  - 恢复root密码
tags:
  - Linux
  - 渗透安全
  - 学习笔记
  - Vim
  - 网络配置
source: "[[VIP班笔记资料]] 第4章-Vim编辑器-xshell-xftp工具-Linux基本操作v18"
---

# 第四章 Vim编辑器-Xshell工具-Linux基本操作

> 来源：Web安全渗透+Kali渗透高级工程师 VIP 课程

---

## 4.1 Vim 的使用

### vi vs vim

> **vim 是 vi 的增强版**，最明显的区别：vim 支持**语法高亮**，完全兼容 vi。

```bash
rpm -qf /usr/bin/vim               # 查看 vim 由哪个软件包安装
which vim                          # 查看 vim 路径
rpm -qf `which vim`                # 反引号命令替换
rpm -qf $(which vi)                # $() 命令替换（效果相同）
```

### 4.1.1 Vim 四种模式

| 模式 | 进入方式 | 用途 |
|------|----------|------|
| **正常模式** (Normal) | 打开文件默认进入 | 光标移动、复制粘贴、删除 |
| **插入模式** (Insert) | 按 `i` `a` `o` 等 | 编辑文本 |
| **命令行模式** (Command-line) | 按 `Esc` 后输入 `:` | 保存、退出、查找替换 |
| **可视模式** (Visual) | `Ctrl+V` | 块选择、批量操作 |

```
进入文件 → 正常模式 → 按 i → 插入模式 → 按 Esc → 命令模式 → 输入 : → 命令行模式
```

> ⚠️ 命令模式下输入无效时，检查输入法是否切到英文！

**进入编辑模式的 6 种方式：**

| 按键 | 说明 |
|------|------|
| `i` | 当前字符**之前**插入（光标前） |
| `I` | **行首**插入 |
| `a` | 当前字符**之后**插入（光标后） |
| `A` | **行尾**插入 |
| `o` | **下一行**插入（另起一行） |
| `O` | **上一行**插入 |

**小操作：**

| 按键 | 作用 |
|------|------|
| `x` | 向后删除一个字符（等于 Delete） |
| `X` | 向前删除一个字符 |
| `u` | 撤销一步（可连续按） |
| `Ctrl+R` | 恢复撤销 |
| `r` | 替换当前字符 |

### 4.1.2 正常模式操作

**1. 光标定位：**

| 操作 | 效果 |
|------|------|
| `h` `j` `k` `l` | 左 下 上 右 |
| `0` / `Home` | 跳到**行首** |
| `$` / `End` | 跳到**行尾** |
| `gg` | 跳到文档**首行** |
| `G` | 跳到文档**末行** |
| `3gg` 或 `3G` | 跳到第 **3** 行 |

**2. 查找：**

```bash
/string        # 查找字符串，回车定位
               # n = 下一个，N = 上一个
:noh           # 取消高亮
/^d            # 查找以 d 开头的内容（^ = 开头）
/bash$         # 查找以 bash 结尾的内容（$ = 结尾）
```

**3. 复制、删除、粘贴：**

| 操作 | 效果 |
|------|------|
| `yy` | 复制当前行 |
| `2yy` | 复制 2 行 |
| `dd` | **剪切**当前行（最常用） |
| `2dd` | 剪切 2 行 |
| `D` | 从光标处删除到行尾 |
| `p` | 粘贴 |

### 4.1.3 可视块模式（批量操作神器）

**批量删除（如去掉注释 `#`）：**
```
Ctrl+V → 移动光标选中 → 按 d 删除
```

**批量添加（如批量注释 `#`）：**
```
Ctrl+V → 移动光标选中多行行首 → 按 I（大写） → 输入 # → 按 Esc
```

> 🔥 改服务器配置文件时，批量注释/取消注释超好用！

### 4.1.4 命令行模式

**保存退出：**

| 命令 | 效果 |
|------|------|
| `:w` | 保存 |
| `:w!` | 强制保存 |
| `:q` | 退出（未修改） |
| `:q!` | 不保存强制退出 |
| `:wq` | 保存并退出 |
| `:wq!` | 强制保存并退出 |
| `:x` | 保存并退出 |
| `ZZ` | 保存并退出（正常模式下） |
| `ZQ` | 不保存退出（正常模式下） |

**其他实用命令：**

```bash
:!ifconfig       # 在 vim 中调用外部命令
:set nu          # 显示行号
:set nonu        # 取消行号
:noh             # 取消高亮
```

> 📖 **vimtutor** — vim 自带教程，终端输入即可学习！

---

## 4.2 远程连接工具 — Xshell & Xftp

> 注：本节大量截图，文字内容较少，建议配合 PDF 原版看图操作。

### Xshell 要点

- 连接新服务器：新建会话 → 输入 IP + 端口 → 输入用户名密码
- 调整字体大小：工具栏直接调整
- 解决小键盘无法输入数字：属性 → 终端 → 键盘 → 设为 Normal
- 在全部会话执行命令：工具 → 发送键到所有会话
- 双击标签页可快速打开新会话

### Xftp 要点

- 安装后，在 Xshell 中可直接调用 Xftp 传输文件
- 鼠标拖动文件即可上传/下载
- 如果没有 `rz`/`sz` 命令：`yum -y install lrzsz`

---

## 4.3 Linux 网络相关概念和修改 IP 地址

### 4.3.1 网卡命名规则

| 版本 | 命名方式 | 示例 |
|------|----------|------|
| CentOS 6 | 连续号码，不固定 | `eth0` `eth1` |
| CentOS 7+ | dmidecode 采集，永久唯一 | `ens33` `enp33` `enp2s0` |

**CentOS 7 命名规则解读（`enXnnn`）：**

| 前缀 | 含义 |
|------|------|
| `en` | Ethernet 以太网 |
| `ens` | 热插拔网卡（USB 等，s = slot） |
| `eno` | 主板板载网卡（o = onboard） |
| `enp` | 独立 PCI 网卡（p = pci） |
| 数字 | MAC 地址 + 主板信息计算得出 |

### 4.3.2 ifconfig 命令

```bash
ifconfig           # 查看所有活动网卡
ifconfig -a        # 查看所有网卡（含未启动的）
```

**输出解读：**
```
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.0.63  netmask 255.255.255.0  broadcast 192.168.0.255
        ether 00:0c:29:26:66:2d  txqueuelen 1000  (Ethernet)
        RX packets 1110  bytes 121630 (118.7 KiB)
        TX packets 203   bytes 13240 (12.9 KiB)
```

| 字段 | 含义 |
|------|------|
| UP | 网卡开启 |
| BROADCAST | 支持广播 |
| RUNNING | 网线已连接 |
| MULTICAST | 支持组播 |
| mtu 1500 | 最大传输单元 1500 字节 |
| inet | IPv4 地址 |
| ether | MAC 地址 |
| RX/TX | 接收/发送数据包统计 |

### 4.3.3 临时修改 IP

> ⚠️ 重启网络服务/网卡/系统后失效，仅用于调试！

```bash
# 添加临时 IP
ifconfig ens160:0 192.168.1.111 netmask 255.255.255.0

# 查看
ip a                     # 或 ip addr show

# 删除临时 IP
ip addr delete 192.168.0.111 dev ens160:0
```

### 4.3.4 永久修改 IP — 编辑网卡配置文件

```bash
vim /etc/sysconfig/network-scripts/ifcfg-ens160
```

**关键参数：**

| 参数 | 可选值 / 说明 |
|------|-------------|
| `BOOTPROTO` | `dhcp` 动态 / `static` 静态 / `none` 不指定 |
| `ONBOOT` | `yes` ← **必须！** 否则网卡不启动 |
| `IPADDR` | IP 地址，如 `192.168.1.63` |
| `PREFIX` | 子网掩码，`24` = `255.255.255.0` |
| `GATEWAY` | 默认网关 |
| `DNS1` | 首选 DNS |

**常用 DNS：**

| DNS | 归属 |
|-----|------|
| `223.5.5.5` | 阿里 |
| `114.114.114.114` | 电信 |
| `116.116.116.116` | 联通 |
| `8.8.8.8` | Google |

**重启网络：**
```bash
service network restart          # CentOS 6/7
systemctl restart network        # CentOS 7
```

### 4.3.5 网络相关配置文件

| 文件 | 作用 |
|------|------|
| `/etc/sysconfig/network-scripts/ifcfg-ens160` | 网卡 IP 配置 |
| `/etc/sysconfig/network-scripts/ifcfg-lo` | 回环地址 |
| `/etc/resolv.conf` | DNS 配置 |
| `/etc/hosts` | 主机名 ↔ IP 绑定 |
| `/etc/hostname` | 主机名 |

**/etc/hosts 示例：**
```
192.168.0.63  xuegod63  xuegod63.cn
192.168.0.62  xuegod62  xuegod62.cn
192.168.0.64  xuegod64  xuegod64.cn
```

**修改主机名：**
```bash
hostnamectl set-hostname xuegod63.cn    # 永久修改
hostname aaa.com                        # 临时修改（重启失效）
cat /etc/hostname                       # 查看主机名
```

---

## 4.4 实战：进入紧急模式恢复 root 密码

> 🎯 场景：CentOS 7 忘记 root 密码，需找回 root 身份。

### 操作步骤

**1. 重启，进入 GRUB 编辑模式**
- 重启 → 按 `↑↓` 键停止倒计时 → 选择第一项 → 按 `e` 编辑

**2. 修改启动参数**
- 找到 `Linux16` 开头的行
- 在行尾空格后添加 `rd.break`
- （可选：把 `ro` 改成 `rw`，则无需重新挂载）

**3. 进入紧急模式**
- 按 `Ctrl+X` 启动

> 原理：打断正常启动流程，进入一个 bash 环境，系统并未真正启动。

**4. 重新挂载根目录（读写）**
```bash
mount -o remount,rw /sysroot
```

**5. 换根并修改密码**
```bash
chroot /sysroot                  # 切换根目录
LANG=en_US.UTF-8                 # 设置英文环境，避免乱码
passwd                           # 修改 root 密码
```

**6. SELinux 处理（如果开启了 SELinux）**
```bash
touch /.autorelabel
```

> ⚠️ 如果 SELinux 是 Enforcing 模式，必须创建 `/.autorelabel` 文件，否则系统重启后 SELinux 安全上下文未更新，密码修改不生效，无法登录！
> 
> 如果 SELinux 是 disabled（已关闭），则不用管。

**7. 退出并重启**
```bash
exit           # 退出 chroot
reboot         # 重启
```

---

## 总结

| 章节 | 内容 |
|------|------|
| 4.1 | Vim 四种模式、光标操作、批量编辑、保存退出 |
| 4.2 | Xshell/Xftp 远程连接与文件传输 |
| 4.3 | 网卡命名、`ifconfig`、临时/永久改 IP、网络配置文件 |
| 4.4 | 🔥 紧急模式恢复 root 密码（`rd.break` + `chroot`） |

---

## 相关笔记

- [[第三节课-文件管理与归档压缩]] — 上一章：文件管理
- [[第二节课-Linux基本命令操作]] — 系统管理命令
- [[01-Projects-进行的项目/新人小白自学挖漏洞路线]] — 漏洞挖掘学习路线
