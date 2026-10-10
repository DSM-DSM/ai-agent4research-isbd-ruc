---
name: html-beautify
description: >
  Use when the user wants to beautify/美化/升级 an existing HTML template or page — make it more 高级/现代/有特点/不套模板, or when they want to design, redesign, shape, critique, audit, polish, animate, review animations, or otherwise improve any frontend interface.
  Also use when the user wants to build a NEW webpage from a description: 新建网页/从零设计/做一个 XX 网站/帮我设计一个 XX 页面 — route through the `match` workflow (search the 58-site design-system resource pool, present template candidates, fall back to from-scratch design when nothing matches).
  Fused from four upstream skills: Impeccable (design direction, 23 commands, anti-pattern detectors), Emil Kowalski's Skills for Design Engineers (animation craft, Apple-style motion rules, UI library picking), Anthropic frontend-design (distinctive visual identity, anti-default calibration), and qiaomu-design (Chinese typography, style fitting room, 58 real-site DESIGN.md library).
  Covers websites, landing pages, HTML templates, dashboards, product UI, app shells, components, forms, settings, onboarding, and empty states. Handles UX review, visual hierarchy, information architecture, cognitive load, accessibility, performance, responsive behavior, theming, anti-patterns, typography (incl. Chinese 中文排版/盘古之白/clreq), fonts, spacing, layout, alignment, color, motion, micro-interactions, animation easing/duration/physics, UX copy, error states, edge cases, i18n, and reusable design systems or tokens. Also use for bland designs that need to become bolder or more delightful, loud designs that should become quieter, live browser iteration on UI elements, or ambitious visual effects that should feel technically extraordinary. Not for backend-only or non-UI tasks.
version: 1.1.1
user-invocable: true
argument-hint: "[match · shape · audit|critique · animate|bolder|colorize|delight|layout|overdrive|quieter|typeset · adapt|clarify|distill · harden|onboard|optimize|polish · init|document|extract|live · review-animations|improve-animations|find-animation-opportunities|animation-vocabulary|apple-design|pick-ui-library] [target]"
license: Apache 2.0
allowed-tools:
  - Bash(npx impeccable *)
  - Bash(node .claude/skills/html-beautify/scripts/*)
metadata:
  provenance: self-improving-skills

---
This skill gives you the tools and permission to create design that earns to be called out-of-distribution craft: Whereas before, your design work would have been safe, timid and measured, you now approach every design task as an award-winning design director with impeccable understanding for what makes exceptional design work: production-grade code, peak creativity, a clear POV, deep understanding of the needs of the client and users, and exceptional craft — including animation and motion that "feels right", not just runs.

Core principles:
- Go all out. No hedging, no shortcuts. The deliverable must be complete (except assets the user must provide).
- Dream big and bold. Distinct, beautiful, outstanding and highly inspiring work.
- Verify in bounded passes, not a loop, and the ceiling covers the whole cycle: screenshots, defect scans, micro-edits, and rebuilds alike. Build fully, inspect once with a batched round (desktop and mobile together on the web; the shipped device classes on a native platform), fix everything it shows in one batch, confirm with at most one more round, and stop polishing. Open-ended self-QA burns the user's money doing worse what the finish handoffs do better.
- Agents don't have great taste. Small animation and craft mistakes compound: a wrong easing curve, a popover scaling from center instead of its trigger, a solid border where a semi-transparent shadow belongs. Before touching motion, load the animation playbook ([reference/emil/emil-design-eng/SKILL.md](reference/emil/emil-design-eng/SKILL.md)).

## Upstream update check (rule 0, highest priority)

This skill fuses four upstreams: `pbakaus/impeccable`, `emilkowalski/skills`, `anthropics/skills` (frontend-design), and `joeseesun/qiaomu-design`. Each session it is triggered, run:

```bash
curl -s "https://api.github.com/repos/pbakaus/impeccable/commits?path=.claude/skills/impeccable&per_page=1" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['sha'])" 2>/dev/null
curl -s "https://api.github.com/repos/emilkowalski/skills/commits?path=skills&per_page=1" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['sha'])" 2>/dev/null
curl -s "https://api.github.com/repos/anthropics/skills/commits?path=skills/frontend-design&per_page=1" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['sha'])" 2>/dev/null
curl -s "https://api.github.com/repos/joeseesun/qiaomu-design/commits?per_page=1" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['sha'])" 2>/dev/null
```

Compare each SHA with the matching `last_merged_sha` in `C:\Users\YJY\.claude\skills\html-beautify\upstreams.json`. If any differs, tell the user once: 「⚠️ html-beautify 的上游（impeccable/emilkowalski/frontend-design/qiaomu-design）有更新，建议空闲时更新：告诉我"更新 html-beautify"即可。更新命令：`powershell .claude/skills/html-beautify/check-updates.ps1 -Diff` 看变化，`-AutoMerge` 自动合并，合并后重新执行 `sed -i 's|skills/impeccable|skills/html-beautify|g'` 于 scripts/ 与 reference/ 中被跳过的文件。」Then continue the original task — never block on updating. If all match, skip silently.

## Setup

1. Run `node .claude/skills/html-beautify/scripts/context.mjs` once per session (if the runtime shows this skill's loaded base directory, run `node <skill-base-dir>/scripts/context.mjs`; keep cwd at the user's project). Pass a named source file or route as `--target <path>`. It loads PRODUCT.md, DESIGN.md, the matching surface brief, and native-platform guidance when applicable; follow its directives and do not rerun it.
2. Before acting, load the one playbook that owns the request: the Commands table's reference for an explicit or clearly implied sub-command, or [reference/new-work.md](reference/new-work.md) for a new surface or replacement visual world. Then inspect the target and at least one representative source of incumbent visual truth (tokens, theme, CSS, component, or asset) before editing.
3. After analysis and direction are resolved, load [reference/craft-floor.md](reference/craft-floor.md) immediately before editing UI. It carries the quality floor, the absolute bans, and the reflexes no detector catches. Do not load it for planning-only work.

## How to design

- **The brief wins.** Honor pinned aesthetics, eras, materials, fonts, and palettes even when they conflict with a saturated-pattern warning. Redirecting a clear brief toward your taste is failure.
- **Refinement preserves; redesign replaces.** Refinement keeps the incumbent identity, behavior, copy, and everything outside scope. Ask before replacing factual copy or adding claims. Redesign keeps product truth, content, function, native affordances, and constraints, but treats the old look as evidence and anti-reference; choose a replacement world in new-work and replace DESIGN.md. Never split the difference into polish on the discarded look.
- **Visual authority is evidence, not a filename.** Missing DESIGN.md alone does not make a project greenfield; new-work decides whether to preserve, expand, or replace the incumbent world.
- **A plain-HTML template is a real surface.** When the target is a standalone HTML file (no build system), treat its inline `<style>` block and existing markup as the incumbent visual truth; refinement happens in place, redesign replaces the style world while preserving content and structure. All motion rules apply to vanilla CSS/JS exactly as they do to frameworks.
- **Escape the three default AI looks.** For calibration: AI-generated design right now clusters around (1) warm cream background + serif display + terracotta accent; (2) near-black + single bright acid-green/vermilion accent; (3) broadsheet with hairline rules and zero border-radius. Legitimate for some briefs, but they are defaults, not choices. Where the brief leaves an axis free, don't spend that freedom on one of these. Full discipline in [reference/frontend-design.md](reference/frontend-design.md).
- **Every design gets one signature.** From the same source: spend boldness in one place — the single unique element the page will be remembered by. Everything else stays quiet and disciplined. Chanel's advice: before leaving the house, take a look in the mirror and remove one accessory.

## Modes

The mode names what the visitor's success looks like on this surface.

- **Persuade:** the visitor decides and acts; design is the product. Landing pages, marketing, campaigns, pricing. Earn attention and action. Ship real imagery when the brief needs it; follow the committed world, not category habit.
- **Operate:** the visitor completes a task. App UI, dashboards, editors, admin, settings, tools. Scanability, consistency, native expectations, and the real usage scene outrank expression. Brand lives in precise details.
- **Read:** the visitor understands something. Docs, articles, guides, help, changelogs. Structure for comprehension, then make the reading experience worth staying in.
- **Experience:** the visitor is inside the work itself. Portfolios, galleries, showcases. Let the artifact lead from the first viewport; the interface recedes.

Choose the mode from the requested surface, not the product, and persist it only in that surface brief. A tool's landing page is still Persuade; a fashion house's documentation is still Read; a docs index is Read, not Persuade. See [new-work.md](reference/new-work.md) for new surfaces and [operate.md](reference/operate.md) for deeper Operate/Read guidance.

## Commands

| Command | Category | Description | Reference |
|---|---|---|---|
| `match [description]` | Build | NEW PAGE: search the 58-site design-system pool, present template candidates, fall back to from-scratch design | [resource pool workflow](#resource-pool--match-workflow-new-pages) · catalog: [reference/qiaomu/references/design-systems-catalog.md](reference/qiaomu/references/design-systems-catalog.md) |
| `craft [feature]` | Build | Deprecated alias for an ordinary new-work request | [reference/craft.md](reference/craft.md) |
| `shape [feature]` | Build | Plan UX/UI before writing code | [reference/shape.md](reference/shape.md) |
| `init` | Build | Capture durable product context in PRODUCT.md | [reference/init.md](reference/init.md) |
| `document` | Build | Generate DESIGN.md from existing project code | [reference/document.md](reference/document.md) |
| `extract [target]` | Build | Pull reusable tokens and components into design system | [reference/extract.md](reference/extract.md) |
| `critique [target]` | Evaluate | UX design review with heuristic scoring | [reference/critique.md](reference/critique.md) |
| `audit [target]` | Evaluate | Technical quality checks (a11y, perf, responsive) | [reference/audit.md](reference/audit.md) · native: [reference/audit.native.md](reference/audit.native.md) |
| `polish [target]` | Refine | Final quality pass before shipping | [reference/polish.md](reference/polish.md) |
| `bolder [target]` | Refine | Amplify safe or bland designs | [reference/bolder.md](reference/bolder.md) |
| `quieter [target]` | Refine | Tone down aggressive or overstimulating designs | [reference/quieter.md](reference/quieter.md) |
| `distill [target]` | Refine | Strip to essence, remove complexity | [reference/distill.md](reference/distill.md) |
| `harden [target]` | Refine | Production-ready: errors, i18n, edge cases | [reference/harden.md](reference/harden.md) |
| `onboard [target]` | Refine | Design first-run flows, empty states, activation | [reference/onboard.md](reference/onboard.md) |
| `animate [target]` | Enhance | Add purposeful animations and motion (craft rules from Emil Kowalski) | [reference/animate.md](reference/animate.md) · [reference/emil/animate/SKILL.md](reference/emil/animate/SKILL.md) |
| `colorize [target]` | Enhance | Add strategic color to monochromatic UIs | [reference/colorize.md](reference/colorize.md) |
| `typeset [target]` | Enhance | Improve typography hierarchy and fonts | [reference/typeset.md](reference/typeset.md) |
| `layout [target]` | Enhance | Fix spacing, rhythm, and visual hierarchy | [reference/layout.md](reference/layout.md) |
| `delight [target]` | Enhance | Add personality and memorable touches | [reference/delight.md](reference/delight.md) |
| `overdrive [target]` | Enhance | Push past conventional limits | [reference/overdrive.md](reference/overdrive.md) |
| `clarify [target]` | Fix | Improve UX copy, labels, and error messages | [reference/clarify.md](reference/clarify.md) |
| `adapt [target]` | Fix | Adapt for different devices and screen sizes | [reference/adapt.md](reference/adapt.md) · native: [reference/adapt.native.md](reference/adapt.native.md) |
| `optimize [target]` | Fix | Diagnose and fix UI performance | [reference/optimize.md](reference/optimize.md) |
| `live` | Iterate | Visual variant mode: pick elements in the browser, generate alternatives | [reference/live.md](reference/live.md) |
| `review-animations [target]` | Motion | Strict craft review of existing animations: Before/After/Why tables | [reference/emil/review-animations/SKILL.md](reference/emil/review-animations/SKILL.md) · [reference/emil/review-animations/STANDARDS.md](reference/emil/review-animations/STANDARDS.md) |
| `improve-animations [target]` | Motion | Codebase-wide animation audit → prioritized, self-contained plan | [reference/emil/improve-animations/SKILL.md](reference/emil/improve-animations/SKILL.md) · [reference/emil/improve-animations/AUDIT.md](reference/emil/improve-animations/AUDIT.md) |
| `find-animation-opportunities [target]` | Motion | Find UI spots that genuinely benefit from motion (and what NOT to animate) | [reference/emil/find-animation-opportunities/SKILL.md](reference/emil/find-animation-opportunities/SKILL.md) |
| `animation-vocabulary` | Motion | Translate vague descriptions ("that bouncy effect") into precise motion terms | [reference/emil/animation-vocabulary/SKILL.md](reference/emil/animation-vocabulary/SKILL.md) |
| `apple-design [target]` | Motion | Apple's WWDC interface/motion principles translated for the web | [reference/emil/apple-design/SKILL.md](reference/emil/apple-design/SKILL.md) |
| `pick-ui-library` | Motion | Choose trusted UI/motion libraries instead of hand-rolled or abandoned ones | [reference/emil/pick-ui-library/SKILL.md](reference/emil/pick-ui-library/SKILL.md) |

Routing:

- **No argument:** read [routing.md](reference/routing.md) and present its context-aware menu; never auto-run a command.
- **Explicit or clearly implied command:** load its reference (native variant on native platforms) and follow it. Ask once if two commands fit.
- **Otherwise:** treat the request as general design work. Missing PRODUCT.md routes a new surface or replacement world through init, then new-work; a narrow refinement of existing code proceeds on the incumbent implementation as context.mjs directs, offering init afterward rather than blocking on it.
- **"美化/升级 my HTML template":** a beautify request without a named command. Run the standard refine flow on it: critique the template first (design + animation lens), report findings with severity, then apply polish/animate fixes in one batch, verify once. Refinement mode — keep the template's content, structure, and identity; upgrade the visual world.
- `teach` aliases `init`. `craft` is a deprecated alias for ordinary new-work and adds nothing. `shape` owns task discovery, then enters new-work only for visual-world and surface-concept decisions.

After init writes PRODUCT.md, resume without rerunning `context.mjs`; init loads the native platform reference itself when the platform it recorded is `ios`, `android`, or `adaptive`.

**Pin / Unpin:** `node .claude/skills/html-beautify/scripts/pin.mjs <pin|unpin> <command>` creates or removes a standalone `/<command>` shortcut. Report the script's result concisely; relay stderr verbatim on error.

**Hooks:** `/html-beautify hooks <on|off|status|ignore-rule|ignore-file|ignore-value|reset>` manages the design detector hook for this project (auto-runs the detector after UI file edits and surfaces findings). Load [reference/hooks.md](reference/hooks.md) when the user invokes it with any argument.

**Triage detector findings before acting on them.** `scripts/detect.mjs` is a static scan and misfires on dense admin/dashboard UIs in three known ways: (1) `broken-image` on an `<img>` whose `src` is assigned at runtime by JS — the scan sees an empty/missing `src`; confirm the assignment exists in code, then ignore. (2) `dark-glow` on neutral slate shadows (e.g. `#182436`) on dark pages — desaturated neutrals are not colored glows; ignore unless the shadow hue is actually chromatic. (3) `flat-type-hierarchy` on an intentional compact scale (e.g. 12/13/14/18 in a kanban/admin tool) — the heuristic wants ≥1.25 ratio steps, but a 4-tier dense scale is legitimate; accept and document rather than inflating type sizes.

**Doctor:** `/html-beautify doctor` reports and repairs drift between this project's Impeccable artifacts (PRODUCT.md, DESIGN.md and its sidecar, config, surface briefs, the hook) and what this version reads. Load [reference/doctor.md](reference/doctor.md) when the user invokes it, or when they ask what is out of date, stale, or needs refreshing. A `CONTEXT_STALE` directive in Setup's output is the cheap subset of the same report; act on it there per its own instructions rather than running doctor unasked.

**Never repair drift as a side effect of a design task.** A `CONTEXT_STALE` finding is reported, not acted on, unless the user asks. The one exception is a finding marked `auto`, which the next write to that file performs anyway.

## Resource pool & match workflow (new pages)

When the user wants to **build a new page** and describes background + design requirements (「帮我做一个 XX 网站，面向 YY，风格要 ZZ」), do NOT start coding. Run the match workflow:

### Step 1 — Read the room, then the catalog

Parse the brief into: page type (landing/portfolio/docs/dashboard/...), audience, vibe words (极简/暖色/深色/奢华/学术/工业/艺术...), and mode (Persuade/Operate/Read/Experience). Then read the resource pool index: [reference/qiaomu/references/design-systems-catalog.md](reference/qiaomu/references/design-systems-catalog.md) — it has a 10-archetype style table (极简精确/暖色高端/深色专业/活力友好/电影沉浸/企业稳重/金融精致/奢华质感/开发者原生/内容优先), a by-product-type table, and a full 58-site directory with one-line style summaries. Match the brief against the **catalog index only** (one file, ~160 lines) — do NOT open individual DESIGN.md files yet.

### Step 2 — Present candidates

Pick 3–5 best-matching sites from the catalog, each with: site name, style summary (from the catalog), and a one-line reason it matches this brief. Present them via AskUserQuestion (multiSelect false, plus the "从零设计" escape hatch) and let the user choose. Also present the inferred 3-dial reading (视觉冒险度/动效强度/信息密度, in Chinese) so the user can adjust before execution.

### Step 3 — Execute by what was chosen

- **User picks a site** → read `reference/qiaomu/references/design-systems/{site}/DESIGN.md` (9 sections: visual theme, palette, typography, component styles, layout principles, depth, do's/don'ts, responsive, agent prompt guide). Build the new page strictly following that design system's tokens and language — transplant the design language onto the user's content, never copy the site's content itself. Mixed choices ("要 A 的配色 + B 的字体") are allowed: merge the two DESIGN.md files explicitly.
- **User picks 从零设计 / no match found** → run the from-scratch path in [reference/frontend-design.md](reference/frontend-design.md): pin the subject → brainstorm a compact token system (4–6 named hex colors, 2+ type roles, a layout concept, ONE signature element) → review the plan against the brief for defaultness before writing code. Take one real aesthetic risk you can justify.
- **Chinese content involved** → before styling, load [reference/qiaomu/references/chinese-typography.md](reference/qiaomu/references/chinese-typography.md) (盘古之白 spacing, ≥14px body, line-height 1.5–1.75, no italics for Chinese UI, system font stack first, subsetted decorative webfonts only).
- **Need a specific effect/component** (光效按钮/粒子背景/加载动画/鼠标特效) → check the external resource pool [reference/pool/external-resources.md](reference/pool/external-resources.md): pure-HTML projects prefer Uiverse or native CSS/GSAP-CDN reimplementation; React projects can use ReactBits/Aceternity/Magic UI; for ready-to-use motion prompts, consult the local catalog [reference/pool/motionsites-catalog.md](reference/pool/motionsites-catalog.md) first (classified by Sites / Sections / Animated Backgrounds, with free/Premium labels and stack recommendations), then fall back to 21st.dev for broader component coverage.

### Style fitting room (optional but recommended for ambiguous briefs)

When the direction is genuinely undecided, use qiaomu's fitting-room protocol (full playbook: [reference/qiaomu/SKILL.md](reference/qiaomu/SKILL.md) Phase 2): produce 4 mutually exclusive mini mockups (A/B/C/D, real typography/color/layout, ~480×300 hero fragments) for the user to pick from — see-then-choose beats describe-then-guess. Never auto-pick or time-out-default; wait for the user's explicit choice.

## Motion craft floor (from Emil Kowalski)

Before adding or judging any animation, internalize these non-negotiable rules (full playbooks under `reference/emil/`):

- **Animation needs a reason.** Spatial continuity, state indication, relationship explanation, feedback, or preventing abruptness — never "looks cool" alone.
- **Easing:** `ease-out` for enter, `ease-in-out` for on-screen movement, `ease` for hover/color. **`ease-in` is forbidden for UI animation.** Durations: button feedback 100–160ms, tooltips 125–200ms, dropdowns 150–250ms, modals/drawers 200–500ms; nothing default-300ms-everywhere.
- **Physics:** never start from `scale(0)` — `scale(0.95)` + `opacity: 0`; popovers scale from their trigger point, not center; button press defaults to `scale(0.97)`.
- **Performance:** animate only `transform` and `opacity` (GPU-composited); never width/height/margin.
- **Accessibility:** honor `prefers-reduced-motion` — keep opacity/color changes, drop positional movement.
- **Interruptibility:** CSS transitions are interruptible; `@keyframes` restart from the beginning. Prefer transitions for gesture-driven UI.
- **Frequency gates intensity:** command palettes and 100+/day actions get no animation; daily interactions get minimal motion; rare/onboarding moments can be expressive.

## 背景图层 / 品牌徽标集成的坑（CSS 层叠 + 素材，实测）

给 HTML 模板加"右下角背景水印 / 品牌 logo"这类图层时的五个实测坑（ruc 校徽集成会话蒸馏）：

- **伪元素背景图只设 width 不设 height → 高度 0，背景完全不渲染。** 单独 `body::after{width:min(24vw,280px)}` 时伪元素无内容、无高度，图"看不见"。必须给高度：`aspect-ratio` 配图片宽高比（如 `848/1248`）或显式 `height`。
- **"内容遮盖背景"必须 `z-index:-1`。** `z-index:0` 的定位元素绘制顺序仍在正常流内容之上——"平级即可"是想当然；要让正文盖住右下角水印，伪元素设 `z-index:-1; pointer-events:none`（绘制在背景色之上、正常流之下）。
- **注入 `<style>` 的 CSS，`url(...)` 相对 HTML 文档目录解析，不相对注入它的 JS。** `theme-pack.js` 注入 `background:url(background-1.png)` 时资源必须和每个 HTML 同目录各放一份副本——JS 在哪个目录不决定资源解析。多模板目录部署逐个拷贝，别指望"JS 目录有就行"。
- **极淡水印素材（beamer 底图）放白底网页肉眼不可见**：最暗像素仅 ~229 灰（对比 <6%），"看不见"往往是素材问题而非层级问题。先 PIL 验像素再动 CSS：`crop(bbox)` 裁水印区域 → 对比度拉伸 `255-(255-p)*k`（k≈3，最暗 229→169）→ CSS `mix-blend-mode:multiply` 融入页面底色。
- **小尺寸品牌 logo 必须用 SVG 矢量。** 把官方 PNG 用 PIL resize 到小尺寸会糊（用户明确反馈"特别模糊"）；favicon / 页眉小标一律引用 SVG 矢量，不要缩位图。

视觉验证见 headless-ui-verify 技能（Playwright msedge channel + evaluate 几何断言优先；Edge CLI 截图仅作退路且必须隔离 `--user-data-dir`；PIL 像素断言替代 Read 图片通道）。
