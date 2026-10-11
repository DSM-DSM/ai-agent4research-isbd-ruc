#!/bin/sh
# =============================================================================
# install.sh — 一键安装本仓库的 AI Agent 技能到 Claude Code / Codex
#
# 用法 A（已 clone 仓库，在仓库根执行）:
#   bash install.sh                 # 装到 Claude Code (~/.claude/skills)
#   bash install.sh --codex         # 装到 Codex (~/.codex/skills)
#   bash install.sh --all           # 两者都装
#   bash install.sh --force         # 覆盖同名技能（默认跳过并提示）
#   bash install.sh --dest <目录>    # 自定义安装根目录（用于测试）
#
# 用法 B（一键远程安装，无需先 clone）:
#   curl -fsSL https://raw.githubusercontent.com/DSM-DSM/ai-agent4research-isbd-ruc/main/install.sh | bash -s -- --remote github
#   curl -fsSL https://gitee.com/AiALi7-9-22/ai-agent4research-isbd-ruc/raw/main/install.sh   | bash -s -- --remote gitee
#   （加 --codex / --all / --force 同用法 A；中国大陆网络建议 --remote gitee）
# =============================================================================
set -e

REPO_GITHUB="https://github.com/DSM-DSM/ai-agent4research-isbd-ruc.git"
REPO_GITEE="https://gitee.com/AiALi7-9-22/ai-agent4research-isbd-ruc.git"

usage() { sed -n '2,16p' "$0" 2>/dev/null || grep -A 14 "用法 A" "$0"; }

TARGET="claude"
FORCE=0
REMOTE=""
DEST=""
while [ $# -gt 0 ]; do
  case "$1" in
    --claude) TARGET="claude"; shift ;;
    --codex)  TARGET="codex";  shift ;;
    --all)    TARGET="all";    shift ;;
    --force)  FORCE=1;         shift ;;
    --remote) REMOTE="${2:-}"; shift 2 ;;
    --dest)   DEST="${2:-}";   shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "未知参数: $1（--help 查看用法）"; exit 1 ;;
  esac
done

# ---- 定位技能源目录 --------------------------------------------------------
TMP=""
cleanup() { [ -n "$TMP" ] && rm -rf "$TMP"; return 0; }
trap cleanup EXIT INT TERM

if [ -n "$REMOTE" ]; then
  case "$REMOTE" in
    github) REPO_URL="$REPO_GITHUB" ;;
    gitee)  REPO_URL="$REPO_GITEE"  ;;
    *) echo "未知 --remote 源: $REMOTE（可选 github | gitee）"; exit 1 ;;
  esac
  command -v git >/dev/null 2>&1 || { echo "远程安装需要 git，请先安装 git 或改用 clone 后本地安装"; exit 1; }
  TMP="$(mktemp -d)"
  echo ">> 拉取技能目录（$REMOTE，sparse checkout，仅技能部分，几百 KB）..."
  git clone --quiet --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TMP/repo"
  git -C "$TMP/repo" sparse-checkout set "AI Agent skills"
  SRC_DIR="$TMP/repo/AI Agent skills"
else
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  SRC_DIR="$SCRIPT_DIR/AI Agent skills"
fi

[ -d "$SRC_DIR" ] || { echo "!! 未找到技能源目录: $SRC_DIR"; echo "   （curl 远程安装请带 --remote github 或 --remote gitee）"; exit 1; }

# ---- 安装函数 --------------------------------------------------------------
install_to() {
  DEST_ROOT="$1"
  AGENT_NAME="$2"
  mkdir -p "$DEST_ROOT"
  INSTALLED=""; SKIPPED=""
  for skill_dir in "$SRC_DIR"/*/; do
    [ -f "$skill_dir/SKILL.md" ] || continue   # 只装含 SKILL.md 的目录
    name="$(basename "$skill_dir")"
    target="$DEST_ROOT/$name"
    if [ -d "$target" ] && [ "$FORCE" -ne 1 ]; then
      SKIPPED="$SKIPPED  - $name（已存在，--force 覆盖）\n"
      continue
    fi
    rm -rf "$target"
    cp -R "$skill_dir" "$target"
    INSTALLED="$INSTALLED  - $name\n"
  done
  echo ">> 已安装到 $AGENT_NAME: $DEST_ROOT"
  [ -n "$INSTALLED" ] && printf "$INSTALLED"
  [ -n "$SKIPPED" ] && printf ">> 跳过:\n$SKIPPED"
}

echo "== ai-agent4research-isbd-ruc · 技能安装 =="
case "$TARGET" in
  claude) install_to "${DEST:-$HOME/.claude/skills}" "Claude Code" ;;
  codex)  install_to "${DEST:-$HOME/.codex/skills}"  "Codex" ;;
  all)
    install_to "${DEST:-$HOME/.claude/skills}" "Claude Code"
    install_to "${DEST:-$HOME/.codex/skills}"  "Codex"
    ;;
esac
echo ">> 完成。重启 Claude Code / Codex 会话后，技能会被自动发现（输入技能名或描述任务即可触发）。"
