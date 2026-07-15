#!/bin/bash
# 二号一键备份 + 提交到 GitHub
# 用法：bash 备份并推送.sh [commit message]
# 功能：
#   1. 检测 v2rayN 代理状态
#   2. 运行技能备份
#   3. Git 提交
#   4. 推送到 GitHub（优先走代理，失败走 ghproxy 备用线）

set -e

VAULT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BACKUP_DIR="$(dirname "$0")"
PROXY_HOST="127.0.0.1"
PROXY_PORT="10808"
MSG="${1:-"备份: 二号技能 ($(date '+%Y-%m-%d %H:%M'))"}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "  备份 + 推送到 GitHub"
echo "  $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

# ====== 0. 检测代理 ======
echo ""
echo "[0/4] 检测 v2rayN 代理..."

if curl -s --connect-timeout 3 --proxy "$PROXY_HOST:$PROXY_PORT" https://github.com > /dev/null 2>&1; then
    echo -e "  ${GREEN}✅ v2rayN 代理在线 (${PROXY_HOST}:${PROXY_PORT})${NC}"
    PROXY_OK=true
elif curl -s --connect-timeout 3 https://github.com > /dev/null 2>&1; then
    echo -e "  ${YELLOW}⚠️  v2rayN 未运行，但网络可直连 GitHub${NC}"
    echo -e "  ${YELLOW}  建议打开 v2rayN 获得更稳定的连接${NC}"
    PROXY_OK=false
else
    echo -e "  ${RED}❌ v2rayN 未运行，且无法直连 GitHub${NC}"
    echo -e "  ${YELLOW}  请打开 v2rayN 后重试${NC}"
    echo ""
    echo "  v2rayN 路径: C:\\Users\\matthew\\Desktop\\v2rayN.exe"
    echo "  启动后确保代理模式为「全局」或「PAC」，端口 ${PROXY_PORT}"
    echo ""
    echo -e "  ${YELLOW}如果 v2rayN 无法使用，脚本将尝试 ghproxy 备用线继续...${NC}"
    PROXY_OK=false
fi

# ====== 1. 运行备份 ======
echo ""
echo "[1/4] 备份技能..."
cd "$BACKUP_DIR" && bash 一键备份.sh

# ====== 2. Git 提交 ======
echo ""
echo "[2/4] 提交到 Git..."
cd "$VAULT_ROOT"
git add -A
git commit -m "$MSG" 2>&1 || echo "  (无可提交的变更)"

# ====== 3. 推送 ======
echo ""
echo "[3/4] 推送到 GitHub..."
PUSH_FAILED=false

if git push 2>&1; then
    echo -e "  ${GREEN}✅ 推送成功${NC}"
else
    PUSH_FAILED=true
    echo -e "  ${RED}❌ 直连推送失败${NC}"

    if [ "$PROXY_OK" = false ]; then
        echo ""
        echo -e "  ${YELLOW}尝试备用方案：ghproxy 镜像推送...${NC}"

        # 临时切换到 ghproxy HTTPS URL
        git remote set-url origin https://ghproxy.com/https://github.com/matthewwx/two.git

        if GIT_SSL_NO_VERIFY=1 git push 2>&1; then
            echo -e "  ${GREEN}✅ ghproxy 备用线推送成功${NC}"
            PUSH_FAILED=false
        else
            echo -e "  ${RED}❌ ghproxy 也失败了${NC}"
        fi

        # 恢复 SSH URL
        git remote set-url origin git@github.com:matthewwx/two.git
    fi
fi

# ====== 4. 总结 ======
echo ""
echo "========================================="
if [ "$PUSH_FAILED" = false ]; then
    echo -e "  ${GREEN}✅ 全部完成！${NC}"
else
    echo -e "  ${RED}⚠️  推送失败，请手动处理${NC}"
    echo "  1. 确认 v2rayN 已启动"
    echo "  2. 确认 GitHub SSH Key 已配置"
    echo "  3. 手动运行: cd vault && git push"
fi
echo "========================================="
