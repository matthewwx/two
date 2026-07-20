---
created: 2026-07-20
aliases:
  - Linux第二节课
  - Linux基本命令
  - Linux命令操作
tags:
  - Linux
  - 渗透安全
  - 学习笔记
  - 命令
source: "[[VIP班笔记资料]] 第2章-Linux基本命令操作和基本管理-v21"
---

# 第二章 Linux基本命令操作

> 来源：Web安全渗透+Kali渗透高级工程师 VIP 课程

---

## 2.1 Linux 终端介绍、Shell 提示符、Bash 基本语法

### 2.1.1 登录 LINUX 终端

**两种终端仿真器：**
- GNOME 桌面 → GNOME Terminal
- KDE 桌面 → Konsole Terminal

**远程连接工具：** Xshell、CRT

**终端类型：**

| 类型 | 说明 |
|------|------|
| tty | 虚拟终端，tty1 图形界面，tty2-6 字符界面 |
| pts | 伪终端，图形界面和 Xshell 远程连接都使用伪终端 |
| /dev/tty | 控制终端，多用户字符界面使用 |

**切换方式：**

| 操作 | 快捷键 |
|------|--------|
| 图形 → 字符终端 | `Ctrl+Alt+F2-6` |
| 字符 → 字符终端 | `Alt+F3-6` |
| 字符 → 图形 | `Alt+F1` |
| 快速打开新终端 | `Ctrl+Shift+T` |
| 终端字体放大 | `Shift+Ctrl+加号` |
| 终端字体缩小 | `Ctrl+减号` |
| 清屏 | `Ctrl+L` |

**查看当前终端：**
```bash
[root@xuegod63 ~]# tty
/dev/pts/0
```

**不同终端之间通讯：**
```bash
# 终端1执行：
[root@xuegod63 ~]# echo xuegod > /dev/pts/1

# 终端2会看到 "xuegod" 输出
```

**广播消息：**
```bash
[root@xuegod63 ~]# shutdown +10      # 10分钟后关机（所有终端收到消息）
[root@xuegod63 ~]# shutdown -c       # 取消关机
[root@xuegod63 ~]# wall "消息内容"    # 广播到所有终端
```

### 2.1.2 认识 SHELL

> Shell 俗称**壳**，是用户与内核之间的接口——接收用户命令 → 送入内核执行。

Shell 本质是**命令解释器**，也有自己的编程语言（循环、分支等）。

**通过 SHELL 可以管理：**

| 编号 | 管理内容 |
|------|----------|
| 1 | 文件管理（创建、删除、复制、修改） |
| 2 | 用户管理（添加、删除） |
| 3 | 权限管理（授权） |
| 4 | 磁盘管理（分区、RAID、LVM） |
| 5 | 软件管理 |
| 6 | 网络管理 |

### 2.1.3 Shell 提示符 `#` 与 `$` 的区别

```
[root@xuegod63 ~]#      ← # 表示 root 管理员
[mk@xuegod63 ~]$        ← $ 表示普通用户
```

**提示符格式解读：**
```
[root    @  xuegod63     ~                        ]#
 用户名---@---主机名------当前目录(~ = 家目录)--------(# root / $ 普通用户)
```

```bash
[root@xuegod63 ~]# su - mk   # 切换到普通用户 mk
[mk@xuegod63 ~]$ exit        # 退出当前 shell
```

### 2.1.4 认识 Bash Shell

**查看所有 Shell 类型：**
```bash
[root@xuegod63 ~]# cat /etc/shells
/bin/sh
/bin/bash
/usr/bin/sh
/usr/bin/bash
```

**查看用户使用的 Shell：**
```bash
[root@xuegod63 ~]# head /etc/passwd -n 1
root:x:0:0:root:/root:/bin/bash
#                                   ↑ 最后一个字段就是 Shell 类型
```

> ⚠️ 第一阶段报错 90% 是两个原因：① 命令字母/空格打错了 ② 当前路径不对

---

## 2.2 基本命令操作

**命令格式：** `命令 【选项】 【参数】`

### 2.2.1 ls — 查看目录内容

作用：查看当前目录下有哪些文件（list）

```bash
ls              # 查看当前目录
ls /            # 查看根目录
ls -l           # 长列表，显示详细信息（权限、大小、时间等）
ls -a           # 显示所有文件，包括 . 开头的隐藏文件
ls -ld /root/   # 查看目录本身的信息，而非目录内容
```

**ls -l 输出解读：**
```
-rw-------. 1 root root 1680 9月 19 12:16 anaconda-ks.cfg
drwxr-xr-x. 2 root root    6 9月 19 13:05 公共
```

**第一个字符表示文件类型：**

| 字符 | 文件类型 | 举例 |
|------|----------|------|
| `d` | 目录文件 | `/etc` |
| `l` | 链接文件 | `/etc/grub2.cfg` |
| `b` | 块设备文件 | |
| `c` | 字符设备文件 | |
| `p` | 管道文件 | |
| `-` | 普通文件 | `/etc/passwd` |

**Linux 文件颜色含义：**

| 颜色 | 文件类型 | 举例 |
|------|----------|------|
| 🔵 蓝色 | 目录 | `/etc` |
| ⚫ 黑色 | 普通文件 | `/etc/passwd` |
| 浅蓝色 | 链接文件 | `/etc/grub2.cfg` |
| 🔴 红色 | 压缩包 | `boot.tar.gz` |
| 🟢 绿色 | 可执行文件 | `/bin/bash` |
| 黑底黄字 | 设备文件 | `/dev/sda` |
| 绿底黑字 | 粘滞位权限目录 | `/tmp` |

### 2.2.2 cd — 切换目录

作用：切换目录（change directory）

```bash
cd                    # 回到当前用户的家目录
cd ~                  # 同上，回到家目录
cd ..                 # 返回上级目录（父目录）
cd .                  # 当前目录
cd -                  # 返回切换前的目录
cd /etc/sysconfig/network-scripts/   # 绝对路径
```

> 💡 `Tab` 键可以补全路径名

### 2.2.3 Linux 快捷键

| 快捷键 | 作用 |
|--------|------|
| `Ctrl+C` | 终止前台运行的程序（如 `ping g.cn` 后停止） |
| `Ctrl+D` | 退出，等价于 `exit` |
| `Ctrl+L` | 清屏，等价于 `clear` |
| `Ctrl+R` | 搜索历史命令 |
| `!$` | 引用上一个命令的最后一个参数 |
| `Esc + .` | 引用上一个命令的最后一个参数 |

```bash
# 示例：!$ 的用法
[root@xuegod63 ~]# cat /etc/hosts
[root@xuegod63 ~]# vim !$      # 相当于 vim /etc/hosts
```

---

## 2.3 系统时间管理

Linux 有**两种时钟**：

| 时钟类型 | 说明 | 查看命令 |
|----------|------|----------|
| 硬件时钟 | 主板上的时钟设备，BIOS 设置 | `hwclock` |
| 系统时钟 | kernel 中的时钟，Linux 指令读取的都是它 | `date` |

> 启动时系统时钟读取硬件时钟，之后独立运作。

### 修改时间

```bash
date -s "2019-11-2 22:30"          # 设置系统时间
date "+%F_%T"                       # 格式化输出 2019-11-02_22:30:00
hwclock -s                          # 以硬件时间为基准，同步系统时间

# 格式符：
# %F = %Y-%m-%d（完整日期）
# %T = 完整时间格式
```

---

## 2.4 帮助命令使用

### 2.4.1 man 命令

```bash
man find    # 查看 find 命令的手册页
# 支持：上翻/下翻/搜索（输入 / 斜线），按 q 退出
```

### 2.4.2 -h 或 --help

```bash
find --help    # 查看命令选项帮助
# 注：find -h 不可执行
```

---

## 2.5 开关机命令及 7 个启动级别

### 2.5.1 shutdown 命令

```bash
shutdown -h +10        # 10分钟后关机
shutdown -h 23:30      # 指定时间点关机
shutdown -h now        # 立即关机
shutdown -r 22:22      # 22:22 重启
shutdown -c            # 取消关机
```

| 参数 | 说明 |
|------|------|
| `-r` | 重启 |
| `-h` | 关机 |
| `-h 时间` | 定时关机 |

**其他关机重启命令：** `init`、`reboot`、`poweroff`

### 2.5.2 7 个启动级别

```bash
init 0-6    # 切换系统运行级别
```

| 级别 | 说明 |
|------|------|
| **0** | 系统停机模式（⚠️ 不能设为默认，否则无法启动） |
| **1** | 单用户模式，root 权限，用于系统维护（类似 Windows 安全模式） |
| **2** | 多用户模式，无 NFS 和网络支持 |
| **3** | 完整多用户文本模式（有 NFS 和网络，命令行控制台） |
| **4** | 保留，一般不用 |
| **5** | 图形化模式（GUI，X Window 系统） |
| **6** | 重启模式（⚠️ 不能设为默认） |

```bash
init 0    # 关机
init 3    # 进入字符界面
init 5    # 进入图形界面
init 6    # 重启
```

### 2.5.3 设置默认运行级别（CentOS 8+）

> CentOS 8 不再使用 `/etc/inittab`，改用 **systemd target**。

| 运行级别 | systemd target |
|----------|----------------|
| 级别 3 | `multi-user.target` |
| 级别 5 | `graphical.target` |

```bash
systemctl get-default                          # 查看当前默认启动级别
systemctl isolate multi-user.target            # 切换到字符界面
systemctl isolate graphical.target             # 切换到图形界面
systemctl set-default multi-user.target        # 设置默认为字符界面
systemctl set-default graphical.target         # 设置默认为图形界面
```

---

## 2.6 实战：设置服务器来电后自动开机

> ⚠️ 此功能需物理机 BIOS 支持，虚拟机不支持。

1. 开机按 `Delete`（或 `F2`、`F1`）进入 BIOS
2. 选择 **Integrated Peripherals** → **SuperIO Device**
3. 找到 **Restore On AC Power Loss**，修改为：
   - **Last State**（推荐）— 保持断电前状态
   - **Power On** — 来电自动开机
   - **Power Off** — 来电不开机

---

## 2.7 实战：设置服务器定时开机

1. 进入 BIOS → **Power Management Setup**
2. 选择 **Wake Up Event Setup** → 回车
3. 找到 **RTC Alarm**，改为 **Enabled**
4. 设置时间和日期
5. `F10` 保存退出

---

## 2.8 配置在线 YUM 源

> 本地 YUM 源版本过低，需配置在线 YUM 源（如阿里云镜像）。

```bash
# 1. 备份原有 YUM 源
mv /etc/yum.repos.d/CentOS-Base.repo /opt/

# 2. 下载阿里云在线源
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo

# 3. 修改为公共地址（去掉云主机内部地址）
sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo

# 4. 生成新的 YUM 缓存
yum makecache
```

---

## 总结

| 章节 | 内容 |
|------|------|
| 2.1 | Linux 终端介绍、Shell 提示符、Bash Shell 基本语法 |
| 2.2 | 基本命令：`ls`、`pwd`、`cd` |
| 2.3 | 硬件时钟与系统时钟（`hwclock`、`date`） |
| 2.4 | 获取帮助（`man`、`--help`） |
| 2.5 | 开关机命令及 7 个启动级别（`shutdown`、`init`、`systemctl`） |
| 2.6 | BIOS 设置来电自动开机 |
| 2.7 | BIOS 设置定时开机 |
| 2.8 | 配置在线 YUM 源 |

---

## 相关笔记

- [[06-wiki/OverTheWire Bandit]] — Linux 命令行闯关练习
- [[01-Projects-进行的项目/新人小白自学挖漏洞路线]] — 漏洞挖掘学习路线
- [[01-Projects-进行的项目/安全渗透]] — 全面安全学习路线
