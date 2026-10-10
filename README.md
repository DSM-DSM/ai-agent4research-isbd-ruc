# ai-agent4research-isbd-ruc

以 **AI Agent 技能**为核心、**HTML 模板**为补充的学术网站项目——中国人民大学 · 统计与大数据研究院（ISBD）。

线上站点：<https://ruc-yjy.site>

## 仓库结构

```
├── index.html            站点导览页（Skills 板块 + 模板库 + 作者卡）
├── AI Agent skills/      两项核心技能的完整定义
│   ├── paper-explainer/  论文 PDF → 中文详解网页 + 跨论文知识图谱
│   └── html-beautify/    网页设计系统与构建（本站即其作品）
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

## 使用

- 全部页面为**纯静态 HTML / CSS / JS**，零构建依赖；双击 `index.html` 即可本地浏览，
  部署到任意静态服务器（NAS / GitHub Pages / nginx）即得完整站点。
- 各模板主题由目录内 `theme-pack.js` 提供，右下角切换方块一键换肤，默认主题为人大红（#971f30）。
- 页脚作者卡支持多作者扩展：在 `authors/` 放置头像文件并复制一个 `.author` 块即可。

## 许可

非商业署名许可：课程作业、学术汇报等非商业场景可免费使用，请署名并标注出处。
