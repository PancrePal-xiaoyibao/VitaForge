#!/usr/bin/env bash
# ============================================================================
# VitaForge 一键部署脚本 (macOS / Linux)
# 用法: 在仓库根目录运行  ./deploy/deploy.sh
# 行为: 合并部署 .claude/.codex/.gemini 到 $HOME，并写入 .agents/skills，重名文件自动备份
# ============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOME_DIR="$HOME"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
YES=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes)
            YES=1
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--yes|-y]"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Usage: $0 [--yes|-y]" >&2
            exit 2
            ;;
    esac
done

echo ""
echo "  ===================================================="
echo "    VitaForge - 一键部署 (macOS/Linux Bash)"
echo "  ===================================================="
echo "  Source:  $REPO_ROOT"
echo "  Target:  $HOME_DIR"
echo ""

if [[ "$YES" -eq 0 ]]; then
    read -r -p "  将合并部署 .claude/.codex/.gemini/.agents，重名文件自动备份。继续？(y/N) " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "  已取消。"
        exit 0
    fi
else
    echo "  非交互模式：已跳过确认。"
fi

merge_vitaforge_dir() {
    local subpath="$1"
    local target_subpath="${2:-$subpath}"
    local src="$REPO_ROOT/$subpath"
    local dst="$HOME_DIR/$target_subpath"
    if [[ ! -d "$src" ]]; then
        echo "  [SKIP] 源不存在: $subpath"
        return
    fi
    mkdir -p "$dst"
    local bak_count=0
    for item in "$src"/*; do
        [[ -e "$item" ]] || continue
        local name="$(basename "$item")"
        local target="$dst/$name"
        if [[ -e "$target" ]]; then
            local bak="$target.vitaforge-bak.$TIMESTAMP"
            mv "$target" "$bak"
            echo "    [BACKUP] $name -> $(basename "$bak")"
            bak_count=$((bak_count + 1))
        fi
        cp -r "$item" "$target"
    done
    echo "  [OK] $subpath -> $target_subpath  (备份 $bak_count 项)"
}

echo ""
echo "  正在部署..."
merge_vitaforge_dir ".claude/skills"
merge_vitaforge_dir ".claude/commands"
merge_vitaforge_dir ".claude/agents"
merge_vitaforge_dir ".claude/scripts"
merge_vitaforge_dir ".codex/skills"
merge_vitaforge_dir ".codex/skills" ".agents/skills"
merge_vitaforge_dir ".gemini/skills"

echo ""
echo "  ===================================================="
echo "    ✅ VitaForge 部署完成！"
echo "  ===================================================="
echo ""
echo "  下一步："
echo "    1. 启动 Claude Code"
echo "    2. 输入 /skill-deploy          做高级融合去重 + 后平滑（推荐）"
echo "    3. 或直接 /vitaforge-orchestrator 开始描述需求"
echo ""
echo "  MCP 配置（可选，提升文献/医学能力）："
echo "    参考 deploy/mcp-config.template.json"
echo ""
