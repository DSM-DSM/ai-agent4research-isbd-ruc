# Pedagogical Patterns for Academic Paper Explanations

These patterns ensure explanations are accessible to readers with limited background while maintaining mathematical rigor.

## Pattern 1: Three-Layer Exposition

For every key concept, provide three progressively deeper layers:

### Layer 1 — Intuition (白话)
- 1-3 sentences, NO formulas
- Use everyday analogies
- Target: someone who has never seen this concept before
- Example: "张量的CP分解就像是把一块复杂的'三维积木'拆成几个简单积木的叠加。"

### Layer 2 — Semi-formal (带注释)
- Show the formula with line-by-line annotations
- Explain each symbol in the formula
- Bridge between intuition and precision

### Layer 3 — Formal (正式)
- Present the complete mathematical definition
- For readers who need precision

Visually distinguish these layers using `.intuition` (Layer 1), plain text (Layer 2), and `.definition` (Layer 3).

## Pattern 2: Analogy Bridge

Always connect unfamiliar tensor concepts to familiar matrix/vector concepts:

| Tensor Concept | Familiar Analogy |
|---|---|
| CP decomposition | SVD / eigendecomposition |
| Mode-k unfolding | Stacking matrix columns |
| Contracted tensor product | Matrix multiplication |
| Broadcasting a univariate function | Element-wise activation (ReLU, sigmoid) |
| Ridge penalty on coefficients | Tikhonov regularization |
| Block coordinate descent | Alternating between fitting different model parts |

## Pattern 3: Concrete-Before-Abstract

Before stating a general formula:
1. Show a small concrete example (e.g., 2×2×2 tensor with actual numbers)
2. Generalize to arbitrary dimensions
3. Connect to the paper's specific use case

## Pattern 4: Question-Answer Threading

Throughout each section:
- Pose the question a curious reader would naturally ask
- Then answer it directly
- Examples:
  - "为什么不能让所有条目共享同一个非线性函数？因为这样太粗糙了..."
  - "为什么选择弹性网而不是纯Lasso？因为张量数据的相邻条目高度相关..."

## Pattern 5: Progressive Difficulty

Structure documents so mathematical sophistication increases gradually:
- Section 0 (reading guide): Absolute minimum notation
- Sections 1-2: Mostly words, occasional formulas
- Sections 3-4: Increasing formula density, always annotated
- Sections 5-6: Full technical rigor, but with plain-language summaries

## Pattern 6: The "So What?" Test

After each theorem or technical result, immediately answer:
- "What does this mean in practice?"
- "How should this affect my modeling choices?"
- "What sample size do I need?"
- "When does this guarantee apply?"

## Pattern 7: Visual Separation

Use the 7 callout box types systematically:
- `.intuition` — Every major new concept starts here
- `.definition` — The formal version of the concept
- `.example` — At least one per major concept
- `.theorem` — Each key theoretical result
- `.algorithm` — All computational procedures
- `.summary` — End of each major section
- `.warning` — Limitations and caveats

## Pattern 8: Section Structure Template

Each major section should follow this internal structure:
1. **Motivation** (2-3 sentences): Why does this section exist? What problem does it solve?
2. **Intuition block**: Plain-language explanation of the core idea
3. **Development**: Step-by-step build-up, alternating `.intuition`, `.definition`, `.example`
4. **Technical details** (if applicable): `.theorem`, `.algorithm` blocks
5. **Summary**: `.summary` block with key takeaways
6. **Transition**: 1 sentence linking to the next section

## Pattern 9: Cross-Referencing

When concepts overlap between papers:
- Add `.crossref` blocks explaining the relationship
- Provide direct hyperlinks between the two HTML files
- Note where terminology differs between papers

## Anti-Patterns (Avoid)

- ❌ Starting a section with a formal definition (start with motivation/intuition)
- ❌ Using notation before defining it
- ❌ Assuming readers know statistical conventions (e.g., what $\asymp$ means)
- ❌ Skipping the "so what" after theorems
- ❌ More than 3 consecutive paragraphs of pure math without an intuition break
- ❌ Chinese-English terminology inconsistency

## Pattern 10: Knowledge Graph Cross-Referencing

When the project contains multiple papers, interlink them systematically:

### Top Navigation Bar
Every paper HTML must have a `<div class="top-nav-bar">` between `<body>` and `<header>`:
```html
<div class="top-nav-bar">
  <a href="other_paper_zh.html">📄 其他论文 详解</a>
  <span class="current">← 当前论文</span>
  <a href="knowledge_graph.html">🗺️ 知识图谱</a>
  <a href="../literature/paper.pdf">📥 原始PDF</a>
</div>
```

### Inline Cross-Reference Blocks (`.crossref`)
Insert at natural connection points within the text:
```html
<div class="crossref">
<strong>📎 知识链接：</strong>[用一两句话说明与另一篇论文的关系——共享了什么概念、在哪个维度上推广、形成什么互补。]
详见 <a href="knowledge_graph.html">知识图谱 → 关系N</a>。
</div>
```

Best locations for `.crossref` blocks:
- After introducing a concept that another paper also uses → "shared foundation" link
- When discussing limitations that another paper addresses → "complement" link
- When the current paper's model is a special/general case → "generalization" link
- At section transitions where concepts overlap between papers

### Footer Related Resources Bar
```html
<div class="related-bar">
  <strong>📚 相关资源：</strong>
  <a href="other_paper_zh.html">📄 其他论文 详解</a>
  <a href="knowledge_graph.html">🗺️ TS2L 知识图谱</a>
  <a href="../literature/paper.pdf">📥 原始PDF</a>
</div>
```

### Reading Guide Cross-References
In Section 0 (阅读导引), include a comparison table showing how the current paper relates to others in the project:
- Response type (scalar vs tensor)
- Linearity (linear vs nonlinear)
- Core mathematical tools
- Inference paradigm (frequentist vs Bayesian)

## Pattern 11: Knowledge Graph Maintenance

### When to Update the Knowledge Graph
After EVERY new paper is added to the project. The graph must be a complete, up-to-date reflection of all papers.

### What to Update
1. **Concept association graph** (`.network-grid`): Add paper node + unique concept tags + adjust shared/bridge zones
2. **Concept-paper matrix** (`.matrix-table`): Add new column + new rows for unique concepts
3. **Relationship cards** (`.rel-card`): Add pairwise relationship descriptions for new paper vs. each existing paper
4. **Reading roadmap** (`.roadmap-steps`): Adjust if new paper changes recommended order
5. **Last-updated date** in `.kg-header`

### Retroactive Updates
When a new paper is added, go back to ALL existing paper HTMLs and:
1. Add the new paper to their `.top-nav-bar`
2. Insert `.crossref` blocks at relevant concept intersections
3. Add the new paper to their `.related-bar`
