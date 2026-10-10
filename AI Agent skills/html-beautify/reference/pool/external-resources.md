# 外部资源池 — 提示词库 / 组件库 / 灵感站

来自小红书笔记调研（2026-08 多篇笔记交叉核实）。这些是**外部网站/组件库**，不属于本 skill 文件，但 match 工作流可按需引用。使用方式：需要具体动效/组件/灵感时查此索引，然后访问对应网站或让用户提供截图。

## 提示词弹药库（复制提示词 → 丢给 AI 执行）

| 资源 | 用途 | 用法 |
|---|---|---|
| **MotionSites.ai** | 数千条高质量网页 AI 提示词（Hero 动画、粒子背景、玻璃态导航、3D 视差）；Sites 完整页 / Sections 区块 / Backgrounds 循环背景 | 浏览画廊 → 复制提示词（Copy 免费 / Premium 付费）→ 粘贴给 AI 生成；提示词精确到 hex/字体/CSS 参数。**本地目录见 [motionsites-catalog.md](motionsites-catalog.md)**，按分类列出免费/Premium 模板与适配场景 |
| **21st.dev** | React+Tailwind 组件聚合，按 Heroes/Backgrounds/Shaders/CTA 分类，自带适配 AI 工具的生成提示词 | 选中组件 → 复制提示词 → 投喂 AI |

## 图标库（喂给 Agent 做图标系统）

| 资源 | 定位 | 备注 |
|---|---|---|
| **Reicon**（[github.com/dqev/reicon](https://github.com/dqev/reicon)，1236⭐） | 2700+ Free SVG Icons，风格统一，可调色/大小，多导出格式 | 线描=未激活 / 填充=激活；先给 Agent 一套统一图标再谈个性化 |
| **morphicons**（[github.com/guillermolg00/morphicons](https://github.com/guillermolg00/morphicons)，1540⭐） | 任意 stroke 图标互相变形（universal morphing），弹簧物理，零依赖；支持 Lucide/Heroicons/Tabler | 做"图标点击后变成另一个图标"的过渡；`npm install morphicons` |

## 动效组件库（代码级复制，适合已有技术栈的项目）

| 资源 | 定位 | 备注 |
|---|---|---|
| **ReactBits**（reactbits.dev，~38k⭐） | 130 个动画 React 组件：文字特效 23 种（BlurText/SplitText/DecryptedText）、鼠标特效 29 种（SplashCursor/ClickSpark/Magnet）、3D/Shader 背景 42 种（Aurora/Galaxy/Hyperspeed） | shadcn 式安装 `npx shadcn@latest add @react-bits/...`；默认栈 motion+gsap+Tailwind |
| **Aceternity UI**（ui.aceternity.com） | 200+ 生产级组件，发光特效/光效按钮/眩光卡/视差滚动/着色器 | 落地页炫酷方向 |
| **Magic UI** | 150+ React+Tailwind 动画组件（Hero/Marquee/粒子/文本动画） | 轻量备选 |
| **Uiverse** | 开源 HTML/CSS UI 元素社区（Hover 效果、渐变、毛玻璃、Loaders） | 纯 HTML 项目友好，零依赖直接复制 |
| **Motion Primitives**（[motion-primitives.com](https://motion-primitives.com)） | 80+ 动效组件（Vue/React 双支持），官网 Playground 每个组件带**「复制提示词」+「复制代码」双按钮** | 前者扔给 AI 复刻，后者直接拷贝即用 |
| **loader-buttons**（[loader-buttons.appllama.io](https://loader-buttons.appllama.io)） | 按钮加载动效组件库：弹性/粒子/流光/打字机/微粒子扩散 | 开箱即用，复制代码/样式；场景：提交按钮、AI 对话按钮、上传下载 |

## 音效 & 等待动画（提升交互感知品质）

| 资源 | 定位 | 备注 |
|---|---|---|
| **UI SFX**（[github.com/romainsimon/uisfx](https://github.com/romainsimon/uisfx)） | 936 个原创 UI 音效 = 78 种语义类别 × 12 种风格（点击/切换/成功/报错/通知/加载），MP3 + JS 库调用 | **CC0 协议**，免费商用 |
| **Thinking Orbs**（[orbs.jakubantalik.com](https://orbs.jakubantalik.com)） | AI 等待动画库：会呼吸/变形/流动的球体，替代 Spinner 转圈；多形态多尺寸/明暗模式/Playground/零依赖 | `npm install thinking-orbs` |

## 数据可视化（Agent Skill 格式）

| 资源 | 定位 | 备注 |
|---|---|---|
| **lieflat-charts**（[github.com/larashero3-dotcom/lieflat-charts](https://github.com/larashero3-dotcom/lieflat-charts)） | 49 种图表模板，CSV/Excel/论文直接丢，输出可交互 HTML（拖拽/缩放/悬停）；配色 Mono 黑白灰保底 + 青瓷蓝/椰林绿/编辑部红三彩色系 | Agent Skills 格式，GitHub 链接发给 AI 即装；国内作者 |

## 灵感/参考站（纯浏览，找方向用）

| 资源 | 用途 |
|---|---|
| **Awwwards** | 全球顶级网页评选，找高分精品落地页 |
| **Land-book** | 轻量灵感画廊（落地页/作品集/电商分类） |
| **SiteInspire** | 按风格/类型/主题筛完整网站 |
| **Recent.Design** | 最新视觉趋势（UI/排版/品牌表达） |
| **designspells** | 顶级产品微动效灵感库（按钮弹性反馈、输入框聚焦律动），治"生硬感" |
| **css-animation 词典**（各类站点） | 加载动画、按钮动效的可视化词典，带配置页可调参 |

## 组件级动效的投喂技巧（来自笔记实测）

1. **代码+文档喂养**：把组件代码和官方文档一起发给 AI："请参考 ReactBits 的 XX 组件，实现逻辑一致的动效，保持原动画曲线和延迟参数"
2. **录屏翻译**：遇到没公开代码的炫酷动效，录屏给 AI 提炼触发时机/缓动函数/关键帧参数，再投喂生成
3. **纯 HTML 模板注意**：ReactBits/Aceternity/Magic UI 都是 React 生态；纯 HTML 项目优先 Uiverse（零依赖）或让 AI 按效果描述用原生 CSS/GSAP CDN 复刻
4. **专业模板投喂（VibeCoding 提质量）**：截图喂 AI 只能学表面，真正的排版逻辑/动效/呼吸感学不到。方法：找专业设计师做好的模板 → 把源码丢给 AI → 改成自己的内容。比花半天教 AI 审美效率高得多（来源：妙思AI网站设计）
