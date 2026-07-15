#!/bin/bash
# 二号技能一键备份
# 用法：bash 一键备份.sh
# 功能：1. 同步 skills/agents 到 vault（用于 GitHub）
#       2. 打包 tar.gz（用于本地快速还原）

set -e

SKILLS_SRC="$HOME/.claude/skills"
AGENTS_SRC="$HOME/.claude/agents"
CLAUDE_JSON="$HOME/.claude.json"
VAULT_BACKUP="$(dirname "$0")"

echo "========================================="
echo "  二号技能一键备份"
echo "  日期: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

# ====== 第一步：同步到 vault（小文件，给 GitHub） ======
echo "[1/4] 同步 Skills 到 vault..."
if [ -d "$SKILLS_SRC" ]; then
    rm -rf "$VAULT_BACKUP/skills"
    cp -r "$SKILLS_SRC" "$VAULT_BACKUP/skills"
    echo "  ✅ $(ls "$SKILLS_SRC" | wc -l) 个技能 → vault/skills/"
fi

echo "[2/4] 同步 Agents 到 vault..."
if [ -d "$AGENTS_SRC" ]; then
    rm -rf "$VAULT_BACKUP/agents"
    cp -r "$AGENTS_SRC" "$VAULT_BACKUP/agents"
    echo "  ✅ $(ls "$AGENTS_SRC" | wc -l) 个 agent → vault/agents/"
fi

echo "[3/4] 同步 MCP 配置..."
if [ -f "$CLAUDE_JSON" ]; then
    cp "$CLAUDE_JSON" "$VAULT_BACKUP/claude.json"
    echo "  ✅ claude.json → vault/"
fi

# ====== 第二步：打包 tar.gz（大文件，本地用） ======
BACKUP_FILE="备份_$(date +%Y%m%d_%H%M%S).tar.gz"
TEMP_DIR="/tmp/skills_backup_$$"

echo "[4/4] 打包完整备份..."
mkdir -p "$TEMP_DIR"
cp -r "$SKILLS_SRC" "$TEMP_DIR/skills" 2>/dev/null
cp -r "$AGENTS_SRC" "$TEMP_DIR/agents" 2>/dev/null
cp "$CLAUDE_JSON" "$TEMP_DIR/claude.json" 2>/dev/null
npm list -g --depth=0 2>/dev/null > "$TEMP_DIR/npm-globals.txt"
pip list --user 2>/dev/null | grep -iE "agent.reach|yt.dlp" > "$TEMP_DIR/pip-packages.txt"

tar -czf "$VAULT_BACKUP/$BACKUP_FILE" -C "$TEMP_DIR" .
rm -rf "$TEMP_DIR"

echo ""
echo "========================================="
echo "  ✅ 备份完成！"
echo ""
echo "  📂 vault 内（GitHub 同步）："
echo "     skills/ ($(ls "$VAULT_BACKUP/skills" | wc -l) 个)"
echo "     agents/ ($(ls "$VAULT_BACKUP/agents" | wc -l) 个)"
echo "     claude.json"
echo ""
echo "  📦 本地还原包："
echo "     $BACKUP_FILE ($(du -h "$VAULT_BACKUP/$BACKUP_FILE" | cut -f1))"
echo ""
echo "  git commit + push 即可同步到 GitHub"
echo "========================================="
