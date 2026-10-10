# MotionSites.ai 资源目录

> 来源：[motionsites.ai](https://motionsites.ai/) — Vibe Coding 专用网页设计提示词与模板库
> 更新日期：2026-08（基于前期调研）
> 状态：部分免费（40+ 套），Premium 需付费

## 概述

MotionSites.ai 不提供现成代码，而是把**高质量网页设计的提示词**产品化——每条提示词是精确到 hex 色值、字体、CSS 参数、布局规格的工程文档（单条 prompt 可达 13,877 字符）。用户复制提示词后粘贴给 Cursor/Claude Code/Codex/Lovable/Bolt.new/v0 等 AI 工具，自动生成生产级、带动效的 React + Tailwind 代码。

### 提示词结构（每条 prompt 包含）

- 视觉主题描述（配色方案、字体选择、整体氛围）
- 布局规格（section 排列、间距、响应式断点）
- 动效参数（缓动曲线、持续时间、stagger 延迟、3D 视差深度）
- 组件细节（按钮样式、卡片圆角、阴影层级、玻璃态参数）
- 技术约束（Tailwind 类名、motion/framer-motion 配置、GSAP 时间轴）

---

## 一、Sites（完整页面模板）

> 适合：从零构建完整网站，复制整页 prompt 后 AI 一次性生成多 section 联动页面

### 免费模板（Copy 标签）

| 模板 | 风格描述 | 适用场景 |
|------|---------|---------|
| 3D Portfolio | 3D 视差滚动 + 项目展示 + 粒子背景 | 个人作品集、设计师主页 |
| Landing Page（基础版） | Hero + Features + CTA 标准结构，微动效 | SaaS 产品页、工具推广页 |
| Agency | 深色专业 + 服务展示 + 团队介绍 | 设计/开发公司官网 |
| SaaS Dashboard Preview | 数据仪表盘预览 + 功能亮点 | SaaS 产品营销页 |
| Web3 / Crypto | 霓虹渐变 + 代币数据展示 | 区块链项目落地页 |

### Premium 模板（Power 套餐含动画背景库）

| 模板 | 风格描述 | 适用场景 |
|------|---------|---------|
| Advanced 3D Portfolio | 增强版 3D + 交互投影 + 自定义光标 | 高端作品集 |
| E-commerce Landing | 商品展示 + 购物车动效 + 支付流程 | 电商推广页 |
| AI Product Launch | 产品发布倒计时 + 特性滚动展示 | AI 工具发布页 |
| Conference / Event | 演讲者卡片 + 议程时间轴 + 报名 CTA | 技术会议/活动页 |
| Mobile App Showcase | 手机模型 + 功能轮播 + 下载引导 | App 推广页 |

---

## 二、Sections（区块组件）

> 适合：已有页面结构，需要升级某个区块的视觉效果；可单独复制后嵌入现有项目

### 按区块类型分类

#### Hero（首屏）

| 模板 | 动效类型 | 技术栈 |
|------|---------|--------|
| Gradient Mesh Hero | 渐变网格流动背景 | CSS + motion |
| Split-Screen Hero | 左右分栏 + 文字逐行显现 | framer-motion |
| Video Background Hero | 全屏视频背景 + 玻璃态文字层 | HTML5 video + backdrop-filter |
| Particle Field Hero | 粒子场 + 鼠标交互引力 | canvas + GSAP |
| Typewriter Hero | 打字机效果 + 光标闪烁 | CSS animation |

#### Pricing（价格表）

| 模板 | 特色 |
|------|------|
| Glassmorphism Pricing | 毛玻璃卡片 + 悬浮高亮 |
| Animated Toggle Pricing | 月/年切换 + 价格数字滚动 |
| Comparison Table Pricing | 功能对比表 + 推荐项脉冲高亮 |

#### Features（功能展示）

| 模板 | 动效类型 |
|------|---------|
| Bento Grid Features | 便当盒布局 + 卡片 hover 抬升 |
| Scroll-Reveal Features | 滚动触发逐块显现 |
| Icon-Morph Features | 图标变形过渡 + 文字淡入 |
| 3D Card Features | 3D 倾斜卡片 + 鼠标跟随光照 |

#### CTA（行动召唤）

| 模板 | 风格 |
|------|------|
| Glowing CTA Button | 光效按钮 + 脉冲光环 |
| Full-Width CTA Band | 全幅色带 + 渐变文字 |
| Floating CTA Card | 悬浮卡片 + 阴影扩散 |

#### Testimonials（用户评价）

| 模板 | 布局 |
|------|------|
| Marquee Testimonials | 无限滚动轮播 |
| Card Stack Testimonials | 卡片堆叠 + 切换动画 |
| Video Testimonials | 视频缩略图 + 播放弹窗 |

#### FAQ（常见问题）

| 模板 | 交互 |
|------|------|
| Accordion FAQ | 手风琴展开 + 图标旋转 |
| Searchable FAQ | 搜索过滤 + 高亮匹配 |

---

## 三、Animated Backgrounds（循环动画背景）

> 适合：需要动态背景的 landing page / hero section；可独立使用或叠加到现有设计

### 免费背景

| 名称 | 效果描述 | 技术实现 | 适配场景 |
|------|---------|---------|---------|
| Neon Pulse | 霓虹脉冲光晕扩散 | CSS radial-gradient + animation | 深色主题、科技产品 |
| Crystal Wave | 水晶波纹折射 | CSS backdrop-filter + blur | 玻璃态设计、高端品牌 |
| Cosmic Ripple | 宇宙涟漪扩散 | canvas + particle system | 太空/未来主题 |
| Gradient Flow | 渐变色彩流动 | CSS @keyframes + multiple gradients | 通用、品牌色展示 |
| Dot Matrix | 点阵矩阵呼吸 | SVG + CSS opacity animation | 数据可视化、开发者工具 |
| Mesh Gradient | 网格渐变扭曲 | WebGL shader 或 CSS filter | 创意机构、艺术项目 |

### Premium 背景（含在 Power 套餐）

| 名称 | 效果描述 |
|------|---------|
| Aurora Borealis | 极光流动效果 |
| Liquid Metal | 液态金属变形 |
| Hyperspeed Tunnel | 超空间隧道穿梭 |
| Galaxy Spiral | 星系螺旋旋转 |
| Firefly Forest | 萤火虫森林漂浮 |

---

## 四、使用建议

### 与 html-beautify 工作流集成

1. **match 工作流 Step 3**：当用户需要"粒子背景/光效按钮/加载动画/鼠标特效"时，先查本目录挑选候选模板，再让用户确认
2. **技术栈匹配**：
   - **纯 HTML 项目** → 选 CSS-only 模板（Neon Pulse、Gradient Flow、Dot Matrix）
   - **React 项目** → 选 framer-motion / GSAP 模板，可直接复制代码
   - **从零设计** → 复制 Sites 整页 prompt 给 AI 生成完整结构
3. **内容替换原则**：提示词中的 hex 色值、字体、间距参数可保留；文字内容、品牌名、图片必须替换为用户自己的内容
4. **与现有资源配合**：
   - 背景 → 本目录 Animated Backgrounds
   - 组件代码 → ReactBits / Aceternity UI / Magic UI（见 external-resources.md）
   - 图标 → Reicon / morphicons
   - 音效 → UI SFX / Thinking Orbs

### 定价参考

| 套餐 | 价格 | 包含内容 |
|------|------|---------|
| Go Unlimited | $149/年 或 $239 一次性 | 仅网站提示词（Sites + Sections） |
| Power | $239/年 或 $349 一次性 | 含动画背景视频库 + Lovable 模板 |

> 免费模板约 40+ 套，覆盖常见场景；建议先用免费模板验证效果，再决定是否升级

---

## 五、免费替代方案

如果不想付费，以下资源可提供类似能力：

| 资源 | 覆盖范围 | 备注 |
|------|---------|------|
| **21st.dev** | 10,000+ 组件以 Prompt 形式，免费浏览，每日 2 次免费复制 | 按 Heroes/Backgrounds/Shaders/CTA 分类 |
| **Magic UI** | 150+ 免费开源 React + Tailwind 动画组件 | Hero/Marquee/粒子/文本动画 |
| **Aceternity UI** | 200+ 暗黑高动效风格组件（部分免费） | 发光特效/光效按钮/视差滚动 |
| **Uiverse** | 完全开源 HTML/CSS UI 元素社区 | 纯 HTML 项目友好，零依赖 |
| **React Bits** | 开源动画 React 组件库（GitHub 44k stars） | 130 个组件：文字/鼠标/3D 背景 |
| **Motion Primitives** | 80+ 动效组件（Vue/React 双支持） | 每个组件带「复制提示词」+「复制代码」双按钮 |
