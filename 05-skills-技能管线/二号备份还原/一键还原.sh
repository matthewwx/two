#!/bin/bash
# 二号技能一键还原
# 用法：bash 一键还原.sh [备份文件名.tar.gz]
# 不带参数则自动查找最新的备份文件

set -e

echo "========================================="
echo "  二号技能一键还原"
echo "========================================="

# 查找备份文件
if [ -n "$1" ]; then
    BACKUP_FILE="$1"
else
    BACKUP_FILE=$(ls -t 备份_*.tar.gz 2>/dev/null | head -1)
fi

if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ 找不到备份文件"
    echo "用法: bash 一键还原.sh 备份_20260715_120000.tar.gz"
    exit 1
fi

echo "📦 使用备份: $BACKUP_FILE"

# 解压
RESTORE_DIR="/tmp/restore_$$"
mkdir -p "$RESTORE_DIR"
tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"
BACKUP_CONTENT=$(ls "$RESTORE_DIR" | head -1)
RESTORE_DIR="$RESTORE_DIR/$BACKUP_CONTENT"

# ====== 前置检查 ======
echo ""
echo "[0/6] 检查前置依赖..."

check_cmd() {
    if command -v "$1" &>/dev/null; then
        echo "  ✅ $1 $( $1 --version 2>&1 | head -1)"
    else
        echo "  ❌ $1 未安装，请先安装"
        MISSING="$MISSING $1"
    fi
}

check_cmd node
check_cmd git
check_cmd python3

if [ -n "$MISSING" ]; then
    echo ""
    echo "请先安装缺失的依赖，然后重新运行此脚本"
    exit 1
fi

# ====== 还原 ======

# 1. 还原 Skills
echo ""
echo "[1/6] 还原 Skills..."
if [ -d "$RESTORE_DIR/skills" ]; then
    mkdir -p "$HOME/.claude/skills"
    cp -r "$RESTORE_DIR/skills/"* "$HOME/.claude/skills/"
    echo "  已还原 $(ls "$RESTORE_DIR/skills" | wc -l) 个技能"
fi

# 2. 还原 Agents
echo "[2/6] 还原 Agents..."
if [ -d "$RESTORE_DIR/agents" ]; then
    mkdir -p "$HOME/.claude/agents"
    cp -r "$RESTORE_DIR/agents/"* "$HOME/.claude/agents/"
    echo "  已还原 $(ls "$RESTORE_DIR/agents" | wc -l) 个 agent"
fi

# 3. 还原 MCP 配置
echo "[3/6] 还原 MCP 配置..."
if [ -f "$RESTORE_DIR/claude.json" ]; then
    cp "$RESTORE_DIR/claude.json" "$HOME/.claude.json"
    echo "  已还原 Claude Code 配置"
fi

# 4. 安装 CLI 工具
echo "[4/6] 安装 CLI 工具..."
echo "  安装 mcporter..."
npm install -g mcporter 2>/dev/null && echo "    ✅ mcporter" || echo "    ⚠ mcporter 安装失败"

echo "  安装 agent-reach(从 Gitee 镜像)..."
if [ ! -d "$HOME/agent-reach" ]; then
    git clone https://gitee.com/mirrors/agent-reach.git "$HOME/agent-reach" 2>/dev/null
    pip install "$HOME/agent-reach" 2>/dev/null && echo "    ✅ agent-reach" || echo "    ⚠ agent-reach 安装失败"
fi

echo "  安装 bun..."
npm install -g bun 2>/dev/null && echo "    ✅ bun" || echo "    ⚠ bun 安装失败"

# 5. 配置 MCP 服务器
echo "[5/6] 配置 MCP 服务器..."
claude mcp add excalidraw --scope user -- npx -y mcp-excalidraw-server 2>/dev/null && echo "  ✅ Excalidraw" || echo "  ⚠ Excalidraw 配置失败"
claude mcp add drawio --scope user -- npx -y @drawio/mcp 2>/dev/null && echo "  ✅ Draw.io" || echo "  ⚠ Draw.io 配置失败"

echo "  配置 mcporter Exa..."
export PATH="$PATH:$HOME/AppData/Roaming/npm"
mcporter config add exa https://mcp.exa.ai/mcp 2>/dev/null && echo "  ✅ Exa 搜索" || echo "  ⚠ Exa 配置失败"

# 6. 清理
echo "[6/6] 清理临时文件..."
rm -rf "$RESTORE_DIR"

echo ""
echo "========================================="
echo "  ✅ 还原完成！"
echo ""
echo "  技能: $(ls "$HOME/.claude/skills" 2>/dev/null | wc -l) 个"
echo "  Agent: $(ls "$HOME/.claude/agents" 2>/dev/null | wc -l) 个"
echo "  MCP: excalidraw / drawio / mcporter"
echo ""
echo "  重启 Claude Code 即可使用"
echo "========================================="
