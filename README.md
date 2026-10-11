# ai-agent4research-isbd-ruc

以 **AI Agent 技能**为核心、**HTML 模板**为补充的学术网站项目——中国人民大学 · 统计与大数据研究院（ISBD）。

线上站点：<https://ruc-yjy.site>

## 仓库结构

```
├── index.html            站点导览页（Skills 板块 + 模板库 + 作者卡）
├── AI Agent skills/      六项技能的完整定义（皆可一键安装）
│   ├── paper-explainer/  论文 PDF → 中文详解网页 + 跨论文知识图谱（自研）
│   ├── html-beautify/    网页设计系统与构建，本站即其作品（自研）
│   ├── prompt-enhancer/  三模式提示词增强器（整合上游 + 自研路由）
│   ├── baton/            跨会话工作交接接力棒（整合上游 + 深度定制）
│   ├── anysearch/        实时搜索引擎：通用 + 垂直域 + 批量并行（社区项目）
│   └── agent-reach/      登录类平台统一路由，15 平台（社区项目）
├── lecture/              讲演幻灯模板（17 套主题）
├── lab-meeting/          组会汇报模板（11 套主题）
├── commerical-lecture/   商业演示模板（7 套主题）
├── paper-explainer/      论文精读库模板（8 套主题）
├── personal-homepage/    学术主页模板（34 套主题）
└── showcase/             真实成品（已脱敏）
    ├── paper-reading/      10 篇 MR×AI 论文精读库（默认人大红，主题可切换）
    ├── weekly-report/      组会周报站演示版（3 页，演示数据）
    └── skills-briefing/    AI 技能汇报页（四条叙事线）
```

## Quick Install（一键安装技能到 Claude Code / Codex）

「AI Agent skills/」下的六项技能（paper-explainer、html-beautify、prompt-enhancer、baton、anysearch、agent-reach）可一键安装到 **Claude Code**（`~/.claude/skills/`）或 **OpenAI Codex**（`~/.codex/skills/`），无需先 clone 本仓库：

**Claude Code**（macOS / Linux / WSL / Windows Git Bash）：

```bash
# GitHub 源
curl -fsSL https://raw.githubusercontent.com/DSM-DSM/ai-agent4research-isbd-ruc/main/install.sh | bash -s -- --remote github
# Gitee 源（中国大陆网络推荐）
curl -fsSL https://gitee.com/AiALi7-9-22/ai-agent4research-isbd-ruc/raw/main/install.sh | bash -s -- --remote gitee
```

**OpenAI Codex**：同上加 `--codex`（装到 `~/.codex/skills/`）；Claude Code 与 Codex 都装用 `--all`。

**Windows PowerShell**：

```powershell
irm https://gitee.com/AiALi7-9-22/ai-agent4research-isbd-ruc/raw/main/install.ps1 | iex
# 需要装到 Codex / 两者都装：先落盘再带参执行
irm https://gitee.com/AiALi7-9-22/ai-agent4research-isbd-ruc/raw/main/install.ps1 -OutFile install.ps1
.\install.ps1 -Target all          # claude | codex | all（GitHub 源把域名部分换回 raw.githubusercontent.com）
```

**已 clone 本仓库**（任意平台，含手动升级已装技能）：

```bash
bash install.sh --all --force      # Windows: .\install.ps1 -Target all -Force
```

**手动安装**：把 `AI Agent skills/<技能名>` 整个目录复制到 `~/.claude/skills/`（Claude Code）或 `~/.codex/skills/`（Codex）即可。

安装脚本采用 sparse checkout，仅拉取技能目录（几百 KB，不下载模板与成品资源）。装好后**重启会话**，输入技能名或直接描述任务（如「帮我精读这批论文 PDF」「帮我从零做一个学术网页」）即自动触发。

## 使用

- 全部页面为**纯静态 HTML / CSS / JS**，零构建依赖；双击 `index.html` 即可本地浏览，
  部署到任意静态服务器（NAS / GitHub Pages / nginx）即得完整站点。
- 各模板主题由目录内 `theme-pack.js` 提供，右下角切换方块一键换肤，默认主题为人大红（#971f30）。
- 页脚作者卡支持多作者扩展：在 `authors/` 放置头像文件并复制一个 `.author` 块即可。

## 许可

非商业署名许可：课程作业、学术汇报等非商业场景可免费使用，请署名并标注出处。
