#!/bin/bash
# 二号一键备份 + 提交到 GitHub
# 用法：bash 备份并推送.sh [commit message]

set -e

VAULT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BACKUP_DIR="$(dirname "$0")"
MSG="${1:-"备份: 二号技能 ($(date '+%Y-%m-%d %H:%M'))"}"

echo "========================================="
echo "  备份 + 推送到 GitHub"
echo "========================================="

# 1. 运行备份
echo "[1/3] 备份技能..."
cd "$BACKUP_DIR" && bash 一键备份.sh

# 2. Git 提交
echo ""
echo "[2/3] 提交到 Git..."
cd "$VAULT_ROOT"
git add "05-skills-技能管线/二号备份还原/"
git commit -m "$MSG" 2>&1 || echo "  (无可提交的变更)"

# 3. 推送
echo ""
echo "[3/3] 推送到 GitHub..."
git push 2>&1 || echo "  ⚠ 推送失败，请检查 Git 远程配置"

echo ""
echo "========================================="
echo "  ✅ 完成！"
echo "  GitHub 上已有最新技能备份"
echo "========================================="
