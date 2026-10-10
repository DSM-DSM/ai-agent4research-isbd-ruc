---
name: paper-explainer
description: |
  阅读学术论文PDF，将其内容浓缩概括为一个自包含的中文HTML详解文档。
  详解覆盖每个章节/段落的背景、数学原理、应用场景和拓展方向，
  以深入浅出的方式展开，适合背景知识有限的读者。支持维护论文间的
  知识图谱和交叉引用网络。通过 @pdf @output_folder 语法指定输入输出路径。
  当用户要求阅读/解读/详解学术论文PDF并生成HTML网页时触发。
version: 2.1.0
metadata:
  provenance: self-improving-skills

---
# Paper Explainer — 学术论文→中文HTML详解 + 知识图谱

将学术论文PDF转化为深入浅出的自包含中文HTML详解文档，并维护多论文之间的知识关联图谱。

## 触发条件

当用户请求包含以下关键词或场景时激活：
- "解读论文" / "详解论文" / "论文中文解读" / "论文总结"
- "阅读PDF" + "生成HTML" / "输出为网页"
- "把这篇论文讲清楚"
- "/paper-explainer"
- "explain paper" / "summarize paper" / "paper to HTML"

## 演示材料契约钩子（生成 HTML 前必查）

详解 HTML 是面向读者的展示型交付物。开始写 HTML 之前，加载
`~/.claude/skills/presentation-contract/references/visual-cognitive.md`
（视觉与认知契约层），其中对本技能直接生效的红线：图内文字可读、
公式符号出现即定义、图表色盲友好、元素密度不超载、无占位残留。
内容结构冲突时以 presentation-contract 的 `references/content-contract.md`
（导师准则）"先看懂再相信"一节为准。

## 调用语法

```
/paper-explainer @<pdf_path> @<output_folder>
```

| 参数 | 标记 | 必需 | 说明 |
|---|---|---|---|
| PDF文件路径 | `@` 前缀 + 路径 | ✅ 必需 | 要解读的学术论文PDF路径，支持绝对路径和相对路径 |
| 输出文件夹 | `@` 前缀 + 路径 | ✅ 必需 | HTML详解和知识图谱的输出目录。如果用户未提供，**必须先提醒用户补充再继续** |

路径可以以 `@` 开头（如 `@./paper.pdf @./output`），或使用自然语言描述（如"把 D:/paper.pdf 解读后保存到 D:/my_project/output"）。

### 参数解析优先级

1. 首先查找 `@path` 格式的显式参数（第一个 `@` 路径为 PDF，第二个为输出文件夹）
2. 如果 `@` 语法不明确，从用户消息中推断 PDF 路径和输出文件夹
3. **如果无法确定输出文件夹，必须提醒用户提供**，不可使用默认值继续执行

## 输入验证（Step 0 — 必须在所有其他步骤之前执行）

在开始任何文件操作之前，执行以下验证：

1. **解析参数**：从用户消息中提取 `@pdf_path` 和 `@output_folder`
2. **验证 PDF**：检查 PDF 文件是否存在且可读
3. **验证或索取输出文件夹**：
   - 如果用户提供了输出文件夹 → 检查是否存在，不存在则自动创建
   - **如果用户未提供输出文件夹 → 停止执行，使用以下消息提醒用户：**

> ⚠️ 请提供输出文件夹路径，例如：
> ```
> /paper-explainer @D:/path/to/paper.pdf @D:/path/to/output_folder
> ```
> 其中 `@output_folder` 用于存放生成的 HTML 详解和知识图谱。

4. 验证通过后，将以下路径记录为本次任务的上下文变量：
   - `PDF_PATH` = 用户提供的 PDF 绝对路径
   - `OUTPUT_DIR` = 用户提供的输出文件夹绝对路径
   - `HTML_DIR` = `{OUTPUT_DIR}`（HTML 详解和知识图谱均直接存放在此目录下）

## 输出

生成两个（或更新多个）HTML文件：

### HTML 文件命名规范

论文详解HTML的命名必须严格遵循以下格式：

```
{第一作者姓氏}_{出版年份}_{论文标题前三个实义词}_zh.html
```

**命名规则：**
1. **第一作者姓氏**：首字母大写，如 `Sanderson`、`Skrivankova`、`Yao`
2. **出版年份**：四位数字，如 `2022`、`2025`
3. **论文标题前三个实义词**：跳过冠词（a/an/the）、介词（of/for/in/on/by/to/from/with）和连接词（and/or），取前三个有实质意义的单词，首字母大写，以下划线分隔
4. 所有部分之间用下划线 `_` 连接

**示例：**

| 论文 | 文件名 |
|---|---|
| Sanderson et al. (2022) "Mendelian randomization" *Nat Rev Methods Primers* | `Sanderson_2022_Mendelian_randomization_zh.html` |
| Skrivankova et al. (2021) "Strengthening the Reporting of Observational Studies in Epidemiology using Mendelian Randomization" *JAMA* | `Skrivankova_2021_Strengthening_Reporting_Observational_zh.html` |
| Yao et al. (2025) "Proteome-Wide Genetic Study in East Asians and Europeans…" *Stroke* | `Yao_2025_Proteome_Wide_Genetic_zh.html` |
| Yoshiji et al. (2025) "Integrative proteogenomic analysis identifies COL6A3-derived endotrophin…" *Nat Genet* | `Yoshiji_2025_Integrative_proteogenomic_analysis_zh.html` |

**知识图谱固定命名：** `knowledge_graph.html`（不随论文变化）

### 输出文件清单

1. **论文详解HTML**：保存在 `{HTML_DIR}/{FirstAuthor}_{Year}_{FirstThreeWords}_zh.html`
2. **知识图谱HTML**：保存在 `{HTML_DIR}/knowledge_graph.html`（如为项目第一篇论文则新建，否则更新）
3. **已有论文HTML更新**：为所有已在 `{HTML_DIR}` 中的已有详解添加指向新论文的交叉引用

## 执行流程（11步）

### Step 1: 整理PDF

将论文PDF复制/移动到 `{HTML_DIR}` 同级的 `literature/` 目录下（如不存在则创建）。

首先确定 `literature/` 目录的位置：
- 如果 `{OUTPUT_DIR}` 同级或父级已有 `literature/` 目录，使用该目录
- 否则在 `{OUTPUT_DIR}` 同级创建 `literature/` 目录

```bash
mkdir -p "{LITERATURE_DIR}"
cp "{PDF_PATH}" "{LITERATURE_DIR}/"
```

### Step 2: 提取PDF文本

```bash
pdftotext "{LITERATURE_DIR}/论文名.pdf" /tmp/paper.txt
wc -l /tmp/paper.txt && head -200 /tmp/paper.txt
```
若PDF加密，告知用户需要无密码版本。

### Step 3: 分析论文结构

参考 `references/paper-structure-guide.md` 的结构分析方法：
1. 识别论文元数据（标题、作者、期刊、年份、DOI）
2. 解析论文章节结构（引言→模型/方法→理论→实验→讨论）
3. 提取每节的关键数学对象和公式
4. 识别实验设置、对比方法和评估指标

### Step 4: 分析知识关联

**如果 `{HTML_DIR}` 中已有论文**，必须分析新论文与已有论文的关系。

#### 4.1 相关性三级分层（🔴 决定后续 Step 9 的链接插入策略）

对每篇已有论文，提取其核心概念集合（从 `<header>` 摘要、标题、关键词），与新论文的核心概念集对比，判定相关性等级：

| 等级 | 判据 | 后续链接策略 |
|---|---|---|
| **强相关** | 满足任一：共享核心方法（Shared）、方法互补可串联（Complements）、一篇是另一篇的升级/细化（Generalizes）、同一生物问题不同角度 | 3 个位置均添加链接 |
| **弱相关** | 同属一大领域（如均涉及 AI/ML 方法、均涉及基因组学数据）但核心主题不同、无法直接串联 | 2 个位置：top-nav-bar + related-bar |
| **无关** | 完全不同领域（如纯临床 MR vs. 纯 DL 模型架构），交集仅在于"同属一个项目" | 仅 1 个位置：top-nav-bar |

判据执行方式：读取已有论文 HTML 的 `<header>` 和首段 `.intuition`，提取 3-5 个核心概念词；与目标论文的核心概念词做交集。交集 ≥2 且可串联 → 强相关；交集 ≥1 但不可串联 → 弱相关；交集 =0 → 无关。

#### 4.2 记录关联映射

对每个核心概念，判断：共享（Shared）/ 推广（Generalizes）/ 互补（Complements）/ 独有（Unique），记录映射供 Step 8 知识图谱和 Step 9 交叉引用使用。

详见 `references/paper-structure-guide.md` 中 Step 8 的完整方法论。

### Step 5: 设计详解大纲

为论文的每个章节规划详解内容。大纲包含：
- **阅读导引（第0节）**：预备知识速览 + 符号约定表 + 与已有论文的关系对比
- **逐章详解**：每个论文章节对应一个讲解章节，覆盖背景动机、数学原理、直观理解、应用场景、延伸讨论
- **交叉引用标记点**：标注在何处插入 `.crossref` 块指向已有论文或知识图谱

### Step 6: 撰写HTML文档

严格遵循 `references/` 中的规范：

| 参考文件 | 用途 |
|---|---|
| `references/html-template.md` | HTML结构、CSS样式、MathJax配置 |
| `references/chinese-terminology.md` | 中英术语对照，确保翻译一致性 |
| `references/pedagogical-patterns.md` | 教学策略：三层展开、类比桥梁等 |
| `references/paper-structure-guide.md` | 论文结构分析方法 |

**HTML必须包含**：
- `<div class="top-nav-bar">` 顶部导航栏（链接知识图谱、其他论文、原始PDF）
- 阅读导引中与其他论文（`{HTML_DIR}` 中的已有解读）的关系说明
- 相关章节中的 `.crossref` 交叉引用块
- `<footer>` 中的 `<div class="related-bar">` 相关资源栏
- MathJax 3 CDN 公式渲染
- <strong>原论文图/表截图 + 逐面板/逐列中文解释</strong>（🔴 强制，2026-08 用户反馈：纯文字页面单调、丧失兴趣且理解不深）。正文引用的每个 Figure 和重要 Table（含可获取的 Supplementary 图表）都要按 <strong>Step 6.5</strong> 截图插入相关章节，图注说明该图/表讲什么、怎么读、与正文论断的关系。此规则只约束新生成的页面——<strong>不批量回改</strong>已生成的旧页面（用户会在其他进程自行处理）。

HTML 中所有指向本项目内其他解读文件或知识图谱的链接，均使用<strong>相对于 `{HTML_DIR}` 的相对路径</strong>（即同级文件名引用，如 `href="knowledge_graph.html"`）。

#### Step 6.5: 从PDF提取原图插入详解（实测 2026-08）

<strong>默认要求（非"用户提出才做"）</strong>：详解文字引用的每个原文图表（图1b、Supplementary Table 1 等）都应截图插入。用户可能点名某一张图/表要求插入，此时执行同样流程。

1. **定位图注页**：`pdftotext` 输出全文 → Python 按 `\f` 分页 → 搜 `Fig. N` + 图注关键词（期刊图注常在文末图版页，Nature Communications 图注含子面板说明 "Fig. 1 ... (a) ... (b) ..."）。
2. **定位图版页**（图与图注分页时）：`pdfimages -list` 看每页嵌入图片数（图版页图片密集）；再用**该页文本层**验证——图内文字标签（a/b/c 子面板标题）会出现在文本层里，据此确认"这页就是 Figure N"。
3. **⚠️ 无法目检图片时的替代验证**：Read 工具在此环境读 PNG/JPEG 均返回 "Unsupported Image"。不要放弃视觉验证——用文本层子面板标签与图注逐一核对（"a=模型示意、b=传统归因、c=PISA"），结构推断代替目检。
4. **渲染与裁剪**：`pdftoppm -f N -l N -r 150 -png` 渲染整页 → Pillow 裁剪顶部页眉 → 转 JPEG q85（~100-300KB）。**⚠️ 页眉高度页页不同**（实测 46 页仅 45px、其余 ≥60px；且页面方向横竖混排），统一裁剪会切掉图内容。裁剪后必须做<strong>像素校验</strong>：统计裁后图片顶部 60px 条带的深色像素占比（灰度 <200），占比 >5% 说明切到了内容，改用更小的裁剪量（15/30/45px 逐档试）。
4b. **🔴 四边收紧（2026-08 用户验收反馈：留白多=不美观）**：只裁页眉不够——渲染页在图表四周常有**大片白边**（实测 PISA Fig3 上下各 500+px、左右各 380px，白边占页面 65%）。裁剪必须做到<strong>四边收紧</strong>：灰度化后逐行/逐列统计深色像素（灰度 <200），找内容<strong>最小包围盒</strong>，四周只留 10-15px 均匀边距。方法：先按行带分析裁掉上下白边（注意图与图注之间的内部空白带不能误裁——取全部内容带的并集边界，而非单个带），再对裁后图按列带分析收紧左右。**验收标准**：任一方向残留白边不得超过该方向尺寸的 20%；读者在 920px 宽页面上浏览时图片内容应填满整行宽。已有图片插入前同样跑四边白边诊断，超标的直接二次收紧（对 JPG 重存 q92 即可，避免从 PDF 重渲染）。
5. **存放与展示约定**：跟随项目先例（TianTanAI 用 `{HTML_DIR}/images/figN_x.jpg` 相对路径引用，先例见 `nav/mr_lecture.html`）；若项目定位要求"自包含"且图片小，改 base64 内嵌。图注逐子面板中文说明 + 标注"图源：Author et al., Journal (Year), CC BY 4.0"。批量插多图时<strong>从后往前插</strong>（按引用行号倒序 Edit），避免行号漂移。<strong>🔴 图片必须水平居中</strong>（2026-08 用户验收反馈：窄图靠左显示不美观）：`img` 是行内元素默认靠左，CSS 只写 `max-width:100%` 时宽图撑满看不出、四边收紧后的窄图明显左偏。居中写法任选其一，但必须落实并逐文件验证：① 追加覆盖规则 `img { display: block; margin-left: auto; margin-right: auto; }`（推荐，不改动原规则即可生效）；② 或原规则直接写 `img { max-width:100%; height:auto; display:block; margin:10px auto; }`。
6. **补充材料图表（Supplementary）不在正文 PDF 中时，先尝试下载 SI 文件**（2026-08 实测）：Nature 系 SI 的静态 URL 模式为 `https://static-content.springer.com/esm/art%3A10.1038%2F<DOI>/MediaObjects/<journalID>_<year>_<artID>_MOESM1_ESM.pdf`（curl -sI 探测，200 即存在；MOESM1 通常是 SI 主文件）。下载后用相同流程定位表格/图（SI 页数少，pdftotext 搜 "Supplementary Table N" 即可；表格区域裁剪用<strong>像素行分析</strong>：找每行深色像素>8 的内容区边界）。SI 也下载不到时才保持文字引用、不插图。
6. **⚠️ Windows 环境坑**：Git Bash 的 `/tmp` 对原生 Windows Python 不可见（`open('/tmp/x.txt')` 报 FileNotFoundError）。pdftotext/pdfimages 的输出路径一律写 D 盘绝对路径（如 `D:/repo/_tmp.txt`），用完清理。
7. **批量提取管线（2026-09 实测：5 篇论文 29 张图表全自动定位裁剪，零目检环境）**：多篇论文/多图任务不要逐图手工试坐标——先跑定位分析拿到全部目标坐标，写一个批量脚本一次产出所有图，漏的目标补跑。目标表每行 `(tag, page, name, x0, y0, x1, y1, cap 或 None)`；cap 写 `'cap:图注开头文字'` 则运行时 `search_for` 现查图注 bbox 替代手写 y1。
   - **三重定位法按图类型分流**：
     - **位图页**：pymupdf `page.get_image_info()` 直接返回嵌入图的精确 bbox（含像素宽高）；
     - **矢量图/表格页**（`get_image_info()` 返回 0 张）：`page.search_for('Figure N: ...')` 拿**图注 bbox 锚点** + `page.get_text('blocks')` 文本块布局（打印 `y[y0-y1] x[x0-x1] 文本前缀` 人读布局）定边界——**图**=图注上方到紧邻正文块底；**表**=表标题（"Table N: ..."）往下到下一正文块顶；
     - **动态定位目标**（页码未知/可能跨页）：`search_for(关键词)` 全文翻页找到页码与 y 范围后再进渲染集合。
   - **双栏页面（IEEE 双栏排版）**：粗窗口的 x 必须用图 bbox 或图注 x 范围限制在单栏内，否则四边收紧会把**另一栏的正文文字**包进内容最小包围盒——收紧算法只认"非白即内容"，分不清栏。单栏全宽图/表才允许 x 放开到页宽。
   - **页眉规避**：页眉 = 页面顶部短文本块（y0 < 60pt），粗窗口上界从页眉底开始（约 y≈46-58pt），别把页眉包进窗口。
   - **统一管线**：粗窗口(pt) → `pdftoppm -f N -l N -r 150 -png -singlefile` 渲染整页 → Pillow `crop()`（pt × 150/72 换算 px）→ 四边收紧（灰度 <240 非白即内容、四周留 12px 边距、内容最小包围盒；numpy `mask = np.array(img.convert('L')) < 240`，行/列 `np.where(mask.any(axis=…))` 取首尾 ±pad）→ JPEG q85。
   - **坑 ①（实测 KeyError）**：动态定位的目标必须**先 search_for 定位并更新目标表、再汇总页码做预渲染**——本次 need_pages 预渲染发生在 TARGETS 更新之前，动态目标换到的新页码没被渲染，进裁剪循环 `rendered[(tag, page)]` 直接 KeyError。正确顺序 = 定位 → 汇总页码 → 渲染 → 裁剪。
   - **坑 ②（跨页大表）**：续到下页的大表放弃截图（单页截不全、双页拼接各含页眉）；改用 HTML 表格重排核心数据行，图注注明"据原文 Table N 重排"。

### Step 7: 验证新论文HTML

- [ ] MathJax公式语法正确，HTML标签闭合完整
- [ ] 目录锚点链接可跳转
- [ ] 7种标注盒（`.definition`/`.intuition`/`.example`/`.theorem`/`.algorithm`/`.summary`/`.warning`）恰当使用
- [ ] 每节有动机说明和要点总结
- [ ] 术语翻译与 `references/chinese-terminology.md` 一致
- [ ] 顶部导航栏和底部相关资源栏完整
- [ ] 文件编码为UTF-8

**多篇/批量任务**：全部页面写完后额外跑一次「批量验证链」（五项断言：链接计数/标签闭合/公式定界符/图片双向引用/日期统一），见下文「多篇论文处理」节。

### Step 8: 更新知识图谱

**新增论文后必须更新** `{HTML_DIR}/knowledge_graph.html`：

需要更新的组件（详见 `references/pedagogical-patterns.md` Pattern 11）：
1. **概念关联图谱** (`.network-grid`)：新增论文节点 + 独有概念标签 + 调整共享/桥梁区域
2. **概念-论文对照矩阵** (`.matrix-table`)：新增列 + 新概念行
3. **论文间关系卡片** (`.rel-card`)：新论文与每篇已有论文的关系描述
4. **推荐阅读路径** (`.roadmap-steps`)：如有必要调整顺序
5. **更新日期** (`.kg-header`)

### Step 9: 回溯更新已有论文（🔴 防止新论文"孤立"的关键步骤）

**目的**：确保新论文的 HTML 页面不是孤岛——已有论文中必须有指向它的双向链接。
根据 Step 4 判定的相关性等级，<strong>分级插入</strong>链接，而非对所有论文一刀切。

#### 9.1 三级链接策略

| 相关性等级 | 链接位置 | 插入内容 |
|---|---|---|
| **强相关** (Shared/Complements/Generalizes) | ① top-nav-bar<br>② 正文 `.crossref` 块<br>③ `.related-bar` | ① 导航链接<br>② 2-3句上下文说明 + 具体关系描述<br>③ 资源栏条目 |
| **弱相关** (同领域不同主题) | ① top-nav-bar<br>② `.related-bar` | ① 导航链接<br>② 资源栏条目 |
| **无关** (完全异领域) | ① top-nav-bar | ① 导航链接 |

#### 9.2 各位置的插入规范

**位置 1 — top-nav-bar**（所有已有论文必加）：

在导航栏已有论文链接的末尾、阅读路径链接之前插入：
```html
<a href="NewPaper_File_Name.html">🔍 ShortLabel</a>
```

**位置 2 — 正文 `.crossref` 块**（仅强相关论文）：

这是防止"孤立"的<strong>核心措施</strong>。执行步骤：
1. 通读目标已有论文中涉及共同概念/方法的段落
2. 在该段落所在 `<section>` 的末尾（`</section>` 之前或 `.summary`/`.warning` 之后）插入 `.crossref` 块
3. `.crossref` 块内容<strong>必须基于两个文件的实际内容</strong>，包含：
   - 1-2句说明两篇论文的具体关系（不得泛泛而谈"两者相关"）
   - 一个指向新论文的超链接
   - 可选：说明两者如何串联使用

格式模板：
```html
<div class="crossref">
  <span class="xref-tag">🔗 交叉引用</span>
  <p>[基于实际内容的 1-2 句关系说明]. 详见 <a href="NewPaper_File_Name.html">Author et al. (Year) — ShortLabel</a>。</p>
</div>
```

**严禁**编造关系描述。如果无法确认两篇论文之间的具体串联方式，降级为弱相关处理——在 `.related-bar` 中添加条目但不插入正文 `.crossref`。

**位置 3 — `.related-bar`**（强相关 + 弱相关论文）：

在底部相关资源栏的知识图谱链接之前插入：
```html
<a href="NewPaper_File_Name.html">ShortLabel (Journal Year)</a>
```

#### 9.3 批量插入后的验证

对每个修改过的文件，执行：
```bash
# 1. 确认链接存在
grep -c "NewPaper_File_Name" <target.html>

# 2. 确认 HTML 标签完整性
# 每次 .crossref 插入前后 div 标签数应保持平衡
```

**⚠️ 已踩坑（2026-08 实测）**：若用 `replace_all=true` 一次替换 top-nav-bar + related-bar 两处，个别论文的 related-bar 结构可能不同（如 PISA 用 `<ul><li>` 列表而非平铺 `<a>`），`replace_all` 会漏插该处。因此批量插入后必须**逐文件核对链接数**是否符合三级策略（强相关=3、弱相关=2、无关=1）：
```bash
for f in *.html; do echo "$(grep -c 'NewPaper_File_Name' "$f")  $f"; done
```
漏插的用 Edit 单独补上（注意匹配目标的结构格式，是 `<li>` 条目还是平铺 `<a>`）。

#### 9.4 导航页同步更新

如果 `{HTML_DIR}/nav/` 下存在 `reading_path.html`（阅读路径主页），添加新论文为新的阅读步骤。

#### 9.5 交叉引用自然度检查

- `.crossref` 块应出现在<strong>概念最相关的段落附近</strong>，而非随机插入
- 关系描述应<strong>具体</strong>（如"PISA 的二维归因矩阵可作为 LyMOI 中 GCN 注意力权重的碱基分辨率补充"），而非泛泛（如"两者都用了深度学习"）

### Step 10: 更新项目CLAUDE.md

如果 `{OUTPUT_DIR}` 同级或父级存在 `CLAUDE.md`，则在"已有输出"表格中添加新条目。
若项目尚无 `CLAUDE.md` 且用户明确要求维护项目文件，则创建一个。

### Step 11: 同步更新所有文件的最后修改日期 🔴 强制

**每次修改任何 HTML 文件或知识图谱后，必须将以下所有文件中的日期统一更新为当天的日期：**

1. **范围**：`{HTML_DIR}/` 及其子目录下的<strong>所有</strong> HTML 文件（论文详解、知识图谱、导航页、补充知识页等）
2. **日期格式**：`YYYY-MM-DD`（如 `2026-06-30`）
3. **更新内容**：
   - `<footer>` 中的"生成于"、"最后更新"、"解读生成日期"等字段
   - `.kg-header` 中的"最后更新"日期
   - `<header>` 中的项目日期
   - 文件内所有出现的旧日期字符串
4. **同时更新** `{OUTPUT_DIR}` 同级或父级的 `CLAUDE.md` 中的日期（如有）

**执行方式**：在 Step 9（回溯更新已有论文）完成后，用脚本扫描所有 HTML 文件，查找并替换所有旧日期为新日期（当天）。

**验证**：修改完成后，用 `grep` 确认整个 `{HTML_DIR}/` 下不存在旧日期字符串。

## 关键质量标准

1. **数学公式前必有直观白话解释**
2. **每个核心概念至少配一个具体小例子**（低维数字演示）
3. **理论结果后必须回答"所以呢？"**（实际含义）
4. **术语首次出现时附英文原文**
5. **章节间有逻辑过渡句**
6. **全文术语翻译统一**（参照 `references/chinese-terminology.md`）
7. **交叉引用自然**——在合适上下文自然提及，非生硬插入
8. **知识图谱完整**——每次新增论文后同步更新
9. **术语不得自相矛盾**（2026-08 实测被读者当场抓住）：简化表述如"普通神经网络"若与后文技术术语（"卷积核"）冲突，懂技术的读者立刻会问"卷积核不是CNN的吗"。对这类读者按实际架构命名（CNN/Transformer），"普通/标准"只用于强调"无领域专用构件"；并说明特性（如motif检测）是<strong>训练收敛的产物</strong>而非预先设计的。
10. **读者卡在输出头/损失函数时，先补"预测目标的数据形态"**（2026-08 实测）：讲清标签从哪来、长什么样（维度+例子）→ 把陌生任务重述为读者熟悉的分类/回归（如"每个read是一票、类别=落点位置"→ 加权交叉熵）→ 最后才给损失公式；用玩具样本（如6维代替1000维）手算softmax+损失全程陪读。
11. **原论文图表插入覆盖率**（2026-08 用户反馈）：新生成的详解页必须尽可能插入原论文中的图/表截图并附逐面板/逐列解释——纯文字页面单调、读者会丧失兴趣且理解不深（见 Step 6"HTML必须包含"与 Step 6.5）。

## 多篇论文处理

输入可以是多个 `@pdf`，也可以是一个装满论文 PDF 的文件夹（逐个枚举目录内 PDF，输出文件夹语义不变）。

当用户提供多篇论文时：
1. 逐篇执行Step 1-7
2. 统筹所有论文间的知识关联（Step 4一次性完成）
3. 撰写所有HTML后，一次性更新知识图谱（Step 8）
4. 批量添加交叉引用（Step 9）
5. 更新CLAUDE.md（Step 10）

### 首写即带交叉引用（2026-09 五篇实战；全新项目的优选，替代 Step 9 先写后回填）

全新项目（`{HTML_DIR}` 为空）时不要"先写完全部再回头补链接"：Step 4 已一次性定案全部论文的**文件命名**与**两两关系**，因此按**知识依赖顺序**写作，写每篇时直接内嵌对已写篇的链接，整个 Step 9 回填环节省去：

- **写作顺序**：基础方法 → 应用/改进 → 数据集 → 前沿评测（本次 HMCN 基础架构 → Chen 两阶段改进 → Asadi 惩罚损失 → MDS-ED 数据集基准 → ECG FM 评测）。依赖序保证写每篇时需要深引的前作都已在盘上，正文 `.crossref` 语义自然；且所有文件名写作前已定案，nav-bar 可直接列出全部兄弟篇（含尚未写的，收尾时全部存在即不悬空）。
- **互引关系证据优先级**（Step 4.1 判强/弱相关时的取信顺序）：**参考文献互引 > 概念交集 > 主观判断**。先翻 PDF 的 References 段——如 Asadi 正文引 Wehrmann [17]/Chen [18]，即直接实锤强相关三角；其次用概念集合交集判据；纯主观印象最弱，尽量不用。
- 增量项目（`{HTML_DIR}` 已有旧论文）仍走 Step 9 回填；首写即带只免除"同批新论文之间"的回填。

### 批量验证链（多篇任务收尾必跑；2026-09 五篇 29 图全 PASS）

全部 HTML + 知识图谱写完后，跑一个 Python 验证脚本一次性断言五项（比逐文件手查可靠，输出逐对/逐文件 PASS/FAIL）：

1. **三级链接计数**：对每对论文（a→b）用 `txt_a.count(文件名_b)` 断言——强相关对 ≥3（top-nav/crossref/related-bar）、弱相关对 ≥2；知识图谱对每篇 ≥2。任一对不满足即 FAIL（专抓 `replace_all` 漏插、related-bar 结构差异漏插，见 Step 9.3）。
2. **HTMLParser 标签闭合校验**：`html.parser.HTMLParser` 子类，starttag 入栈/endtag 出栈比对，用 VOID 集合 `{meta,link,br,hr,img,input,area,base,col,embed,source,track,wbr}` 排除自闭合标签；feed 完栈应空、无 mismatch。比数 `<div`/`</div>` 个数可靠（能抓嵌套错位，本次实抓 1 处标签闭合）。
3. **MathJax 定界符成对检查**：先 `re.sub(r'<script.*?</script>', '', txt, flags=re.S)` 剔除脚本段，断言 `$$` 总数为偶数；再剔除 `$$` 后断言单 `$` 为偶数。**⚠️ bash 坑：双引号内联 python 里的 `$$` 会被 shell 展开成 PID**，Python 实际收到的是数字串 → 计数恒为 0 的假阴性。必须把检查写成 .py 文件再执行（或 bash 用单引号包裹整段）。
4. **图片引用完整性双向断言**：`used ⊆ 磁盘`（src 引用的每张图必须存在）∧ **`磁盘 ⊆ used`（提取出的每张图必须被引用）**——后一方向专抓"提取了但漏插"的图（本次靠它抓到 chen_fig3_padchest 漏插；只查前一方向不会报）。
5. **日期统一断言**：`set(re.findall(r'20\d{2}-\d{2}-\d{2}', txt)) - {当天日期}` 应为空集，等价于"全目录 grep 旧日期应为空"（Step 11 的机检版，别靠肉眼）。

## 教学策略速查

详见 `references/pedagogical-patterns.md`，核心策略：
- **三层展开**：直觉（白话无公式）→ 半形式化（带注释的公式）→ 正式定义
- **类比桥梁**：CP分解↔SVD、收缩张量积↔矩阵乘法、广播↔元素级激活函数
- **具体先于抽象**：先给2×2×2的小例子，再推广到任意维度
- **问答驱动**：预设读者自然产生的问题并回答
- **渐进难度**：阅读导引极少公式 → 引言以文字为主 → 模型/理论逐步增加公式密度

## 术语速查

详见 `references/chinese-terminology.md`，部分高频术语：
- Tensor → 张量 | Broadcasting → 广播 | CP decomposition → CP分解
- Curse of dimensionality → 维度灾难 | B-spline → B样条
- Elastic net → 弹性网 | Ridge penalty → 岭惩罚
- Alternating least squares → 交替最小二乘 | Gibbs sampling → Gibbs采样
