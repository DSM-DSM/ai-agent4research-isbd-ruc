# HTML Template for Paper Explanations

## Overview

When generating Chinese HTML explanations for academic papers, use this template structure. The goal is to produce self-contained, beautifully styled HTML that renders well across browsers and uses MathJax for mathematical notation.

## Required Structure

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[论文标题] —— 详细中文解读</title>
  <style>/* ALL CSS INLINE — see CSS section below */</style>
  <script>MathJax = { tex: { inlineMath: [['$','$'],['\\(','\\)']], displayMath: [['$$','$$'],['\\[','\\]']] }, svg: { fontCache: 'global' } };</script>
  <script async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js"></script>
</head>
<body>
  <header><!-- Title, authors, journal, abstract summary --></header>
  <nav><!-- Table of contents with anchor links --></nav>
  <main>
    <section id="sec-N"><!-- Each major section --></section>
  </main>
  <footer><!-- References, disclaimer, code links --></footer>
</body>
</html>
```

## CSS Design System

Use this inline CSS style block for all paper explanation HTML files:

- **Typography**: `font-family: "PingFang SC", "Microsoft YaHei", "Noto Sans SC", sans-serif`
- **Body**: `font-size: 17px; line-height: 1.75; color: #2c3e50; background: #fafbfc; max-width: 920px; margin: 0 auto; padding: 20px 24px`
- **Headings**: h2→`#1a5276` + border-bottom, h3→`#2471a3`, h4→`#2c3e50`
- **Links**: `color: #2980b9`

## Callout Box Classes (Critical for Pedagogy)

Use exactly these 7 callout box types to structure explanations:

1. **`.definition`** — Blue left border (`#2980b9`), light blue bg (`#eaf2f8`). Tag text: "正式定义".
   - Use for: formal mathematical definitions, model formulas, precise descriptions
   
2. **`.intuition`** — Green left border (`#27ae60`), light green bg (`#e8f8f5`). Tag text: "直观理解".
   - Use for: plain-language explanations, analogies, "In simple terms..." passages
   
3. **`.example`** — Yellow left border (`#f39c12`), light yellow bg (`#fef9e7`). Tag text: "具体示例" or "小例子".
   - Use for: concrete numerical examples, small-dimension illustrations, data scenarios
   
4. **`.theorem`** — Purple left border (`#8e44ad`), light purple bg (`#f4ecf7`). Tag text: "定理/结论".
   - Use for: theorems, propositions, formal theoretical results
   
5. **`.algorithm`** — Gray border (`#d5dbdb`), light gray bg (`#f2f3f4`), monospace font. Tag text: "算法".
   - Use for: pseudocode, algorithm steps, computational procedures
   
6. **`.summary`** — Blue border (`#aed6f1`), very light blue bg (`#ebf5fb`). Tag text: "要点总结".
   - Use for: section summaries, key takeaways, "cheat sheet" content
   
7. **`.warning`** — Red left border (`#e74c3c`), light red bg (`#fdedec`). Tag text: "注意事项" or "关键问题".
   - Use for: limitations, caveats, common pitfalls, important warnings

Each callout box has the structure:
```html
<div class="[type]">
  <span class="tag">[TAG TEXT]</span>
  <h4>[Optional subtitle]</h4>
  <p>[Content]</p>
</div>
```

## Math Rendering

- Inline math: `$...$`
- Display math: `$$...$$`
- Use standard LaTeX: `\mathbb{R}`, `\sum`, `\prod`, `\langle`, `\rangle`, `\circ`, `\|`, `\times`, `\otimes`, `\odot`, etc.
- For matrices: `\begin{bmatrix} ... \end{bmatrix}`
- For aligned equations: `\begin{aligned} ... \end{aligned}`

## Responsive Design

Include: `@media (max-width: 768px) { body { font-size: 15px; padding: 12px 14px; } ... }`

## Navigation

- Each `<section>` has `id="sec-N"` attribute
- `<nav>` contains ordered list of anchor links
- Sub-sections can use `id="sec-N-M"` pattern
- Add `.back-top` links at section ends for convenience
