# Guide: Analyzing Academic Paper Structure

This guide helps systematically extract and organize content from academic papers (especially statistics/ML papers) for explanation generation.

## Step 1: Extract Text

First, extract full text from the PDF using available tools. Try in order:
1. `pdftotext` (poppler-utils) — best for text extraction
2. Python `PyPDF2` or `pdfplumber` — alternative if pdftotext fails
3. If PDF is password-protected, inform user and request unprotected version

Command: `pdftotext "path/to/paper.pdf" /tmp/paper.txt`

Verify extraction quality:
- Read first 100 lines to check for garbled characters
- Count total lines to estimate paper length
- Check for arXiv watermark or journal header that may need stripping

## Step 2: Identify Paper Metadata

Extract:
- **Title**: Usually on first page, largest font
- **Authors**: Below title, with affiliations
- **Journal/venue**: Header or footer area
- **Year**: In citation information
- **DOI/arXiv ID**: Near publication info
- **Abstract**: Labeled "Abstract" or "摘要"
- **Keywords**: Listed after abstract

## Step 3: Parse Section Structure

Standard statistics paper sections (in order):

### Always Present
1. **Introduction** — Background, literature review, contributions
2. **Method/Model** — The proposed approach
3. **Theoretical Results** — Convergence rates, consistency, minimax bounds
4. **Experiments/Simulations** — Numerical validation
5. **Discussion/Conclusion** — Summary, limitations, future work

### Often Present
- **Notation/Preliminaries** — Symbol definitions, background math
- **Algorithm/Computation** — Estimation procedure details
- **Application/Real Data** — Domain-specific case study
- **Supplementary Material** — Technical proofs (usually separate file)

## Step 4: Map Content to Explanation Sections

For each paper section, identify:

### Introduction → Explanation Section 1
- **Background**: What real-world problems motivate this work?
- **Literature review**: What existing methods exist? A comparison table is helpful.
- **Gap**: What is missing from existing work?
- **Contributions**: A numbered list of what this paper achieves.

### Model/Method → Explanation Section 2
- **Model formula**: The central equation(s) — these need the most careful exposition
- **Parameter meaning**: What does each symbol represent in practical terms?
- **Assumptions**: What conditions are required? Are they reasonable?
- **Intuition**: The physical/geometric interpretation

### Algorithm → Explanation Section 3
- **Optimization objective**: What is being minimized/maximized?
- **Algorithm steps**: Pseudocode with Chinese annotations
- **Convergence properties**: Does it converge? To what?
- **Tuning parameters**: What needs to be chosen, and how?

### Theory → Explanation Section 4
- **Setup**: Distributional assumptions, smoothness conditions
- **Main theorem**: Statement + plain-language interpretation
- **Rate interpretation**: What does the rate mean in practice?
- **Optimality**: Is the rate minimax optimal? When?

### Experiments → Explanation Section 5
- **Data generation**: For synthetic data, what distributions and parameters?
- **Competing methods**: What baselines are compared?
- **Metrics**: ISE, MSPE, RPE — define each
- **Key findings**: What patterns emerge? Tables help here.
- **Real data**: Domain context, preprocessing steps, scientific interpretation

### Discussion → Explanation Section 6
- **Limitations**: Honest assessment of when method fails
- **Open problems**: What remains unsolved?
- **Future directions**: Natural extensions

## Step 5: Identify Key Mathematical Objects

For each major formula in the paper, identify:
1. The **domain** of each variable (what space does it live in?)
2. The **dimensionality** (is it a scalar, vector, matrix, tensor?)
3. The **role** (input, output, parameter, hyperparameter, error term?)
4. Any **constraints** (non-negativity, sum-to-one, zero-mean, etc.)

## Step 6: Extract Experiments for Reproducibility

For the experiments section, capture:
- Dimension settings ($p_1, p_2, \dots$)
- Sample sizes ($n$)
- Signal-to-noise ratios
- Number of simulation replicates
- Random seed information (if available)
- Software/packages used (with versions)
- Hardware specs (if reported)

## Step 7: Identify Cross-References Between Papers

When processing multiple related papers:
- Note shared notation (same symbol = same meaning?)
- Note different notation for same concept (need to reconcile in explanations)
- Note hierarchical relationships (does Paper A generalize Paper B?)
- Note complementary approaches (different solutions to same problem)

## Step 8: Knowledge Association Analysis (For Multi-Paper Projects)

When adding a new paper to an existing project with multiple papers, perform systematic knowledge association analysis.

### 8.1 Read All Existing Explanations

Browse the key sections of each existing paper's HTML explanation in `output/`:
- Abstract and reading guide (Section 0) — to understand the problem setting
- Model definition — to identify core mathematical tools
- If applicable, the theoretical results or inference method

### 8.2 Build Concept-Paper Matrix

Map each key concept to which paper(s) use it. Categories:
- **Shared**: Used by multiple papers (→ blue tags in graph, "shared foundation")
- **Paper-specific**: Unique to one paper (→ orange/green tags in graph)
- **Bridge**: Links between papers (→ purple tags in graph)

### 8.3 Determine Relationship Types

For each pair of papers, identify one or more of:
- **Generalizes** (extends/generalizes): Paper A's model is a special case of Paper B, or B extends A along some dimension (e.g., A handles scalar outputs, B handles tensor outputs)
- **Shares foundation** (shares): Both use the same core mathematical tool (e.g., CP decomposition) but for different purposes
- **Complements** (complements): The papers address different aspects of the same problem (e.g., one provides theory, the other provides algorithm/inference)
- **Unique/none**: No substantial overlap — handled separately in graph

### 8.4 Prepare Cross-Reference Inventory

For each existing paper, list:
1. Which sections should receive new `.crossref` blocks pointing to the new paper
2. What topic connects them at each insertion point
3. Which knowledge graph relationship card the link should reference

### 8.5 Plan Knowledge Graph Updates

Determine what needs to change in `output/knowledge_graph.html`:
- New paper node in `.network-grid` + unique concept tags
- New column in `.matrix-table` + new rows for unique concepts
- New `.rel-card` entries for the new paper vs. each existing paper
- Adjust `.roadmap-steps` reading order (if needed)
- Update "last updated" date in header
