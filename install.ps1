# =============================================================================
# install.ps1 — 一键安装本仓库的 AI Agent 技能到 Claude Code / Codex（Windows）
#
# 用法 A（已 clone 仓库，在仓库根执行）:
#   .\install.ps1                      # 装到 Claude Code (~\.claude\skills)
#   .\install.ps1 -Target codex        # 装到 Codex (~\.codex\skills)
#   .\install.ps1 -Target all          # 两者都装
#   .\install.ps1 -Force               # 覆盖同名技能（默认跳过并提示）
#
# 用法 B（一键远程安装，无需先 clone；需联网，两种源按网络选）:
#   无需翻墙（Gitee 源 · 中国大陆推荐）:
#     irm https://gitee.com/AiALi7-9-22/ai-agent4research-isbd-ruc/raw/main/install.ps1 | iex
#   需要翻墙 / 海外网络（GitHub 源）:
#     irm https://raw.githubusercontent.com/DSM-DSM/ai-agent4research-isbd-ruc/main/install.ps1 | iex
#   （GitHub 源失败时脚本内加 -UseGitee 或直接换 Gitee URL）
# =============================================================================
param(
  [string]$Target = "claude",   # claude | codex | all
  [switch]$Force,
  [string]$Dest,                # 自定义安装根目录（用于测试）
  [switch]$UseGitee             # 远程模式下使用 Gitee 源（默认 GitHub）
)

$ErrorActionPreference = "Stop"
$RepoGitHub = "https://github.com/DSM-DSM/ai-agent4research-isbd-ruc.git"
$RepoGitee  = "https://gitee.com/AiALi7-9-22/ai-agent4research-isbd-ruc.git"

# ---- 定位技能源目录（远程执行 $PSScriptRoot 为空 → clone） ----
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "AI Agent skills"))) {
  $SrcDir = Join-Path $PSScriptRoot "AI Agent skills"
  $Tmp = $null
} else {
  $Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("a4r-install-" + [guid]::NewGuid().ToString("N").Substring(0, 8))
  $repoUrl = if ($UseGitee) { $RepoGitee } else { $RepoGitHub }
  Write-Host ">> 拉取技能目录（$(if ($UseGitee) {'gitee'} else {'github'})，sparse checkout，仅技能部分 ..."
  git clone --quiet --depth 1 --filter=blob:none --sparse $repoUrl (Join-Path $Tmp "repo")
  if ($LASTEXITCODE -ne 0) { throw "拉取失败（国内网络可用 Gitee: 加 -UseGitee，或换 gitee 的 URL 重试）" }
  git -C (Join-Path $Tmp "repo") sparse-checkout set "AI Agent skills"
  $SrcDir = Join-Path $Tmp "repo\AI Agent skills"
}

if (-not (Test-Path $SrcDir)) { throw "未找到技能源目录: $SrcDir" }

# ---- 安装函数 ----
function Install-To([string]$DestRoot, [string]$AgentName) {
  New-Item -ItemType Directory -Force -Path $DestRoot | Out-Null
  foreach ($dir in Get-ChildItem -Path $SrcDir -Directory) {
    if (-not (Test-Path (Join-Path $dir.FullName "SKILL.md"))) { continue }
    $target = Join-Path $DestRoot $dir.Name
    if ((Test-Path $target) -and -not $Force) {
      Write-Host "  - $($dir.Name) 跳过（已存在，-Force 覆盖）"
      continue
    }
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Copy-Item -Recurse $dir.FullName $target
    Write-Host "  - $($dir.Name) -> $target"
  }
  Write-Host ">> 已安装到 $AgentName : $DestRoot"
}

Write-Host "== ai-agent4research-isbd-ruc · 技能安装 =="
switch ($Target) {
  "claude" { Install-To ($(if ($Dest) { $Dest } else { Join-Path $HOME ".claude\skills" })) "Claude Code" }
  "codex"  { Install-To ($(if ($Dest) { $Dest } else { Join-Path $HOME ".codex\skills"  })) "Codex" }
  "all"    {
    Install-To ($(if ($Dest) { $Dest } else { Join-Path $HOME ".claude\skills" })) "Claude Code"
    Install-To ($(if ($Dest) { $Dest } else { Join-Path $HOME ".codex\skills"  })) "Codex"
  }
  default  { throw "未知 -Target: $Target（可选 claude | codex | all）" }
}
if ($Tmp) { Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue }
Write-Host ">> 完成。重启 Claude Code / Codex 会话后，技能会被自动发现（输入技能名或描述任务即可触发）。"
