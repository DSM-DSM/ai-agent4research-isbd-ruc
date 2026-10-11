---
name: prompt-enhancer
description: 'Three-mode prompt optimizer merging Aristotelian first-principles, eval-driven iteration, and standard technique-based improvement. Use when user asks to improve/refine/optimize/rewrite/review a prompt, wants "Aristotelian"/"first principles"/"proof-based"/"eval-driven"/"A/B test" mode, or says "/prompt-enhancer". Chinese triggers: 改进提示词, 优化提示词, 提示词优化, 润色提示词, 帮我改提示词, 提示词工程, 改prompt, 优化prompt, 提示词评测, 提示词迭代. Auto-selects mode; user can override.'
metadata:
  provenance: self-improving-skills

---
# Prompt Enhancer

三模式统一提示词增强器。整合 Aristotelian 第一性原理推理、eval 驱动迭代优化、标准技巧工程三套方法论。自动选择最佳模式，用户可手动覆盖。

## Mode Routing（必须首先执行）

| 用户信号 | 选择模式 | 理由 |
|----------|---------|------|
| "Aristotelian" / "第一性原理" / "proof-based" / "从零推导" | **Aristotelian** | 用户明确要求逻辑推导 |
| "A/B test" / "eval" / "评测" / "迭代" / "失败聚类" / 提供了测试用例 | **Eval-Driven** | 有可量化信号 |
| "test this prompt" / "这个是给 GPT 用的" / "跨模型" / "port to" | **Eval-Driven** | 需要模型适配 |
| 复杂推理任务 + 需要解释每步决策 | **Aristotelian** | 推理链价值最高 |
| 一般提示词优化 / 我的提示词太模糊了 / 帮我写好一点 | **Standard** | 默认模式 |
| "帮我看看这个提示词" / "review my prompt" | **Standard** | 快速诊断+改进 |

**冲突消解**: Aristotelian > Eval-Driven > Standard。用户指定优先于自动判断。

---

## 共享工作流（所有模式）

### Phase 0: Intake（所有模式必做）

AskUserQuestion 最多 3 个问题，只问会影响改写方向的信息：
1. **目标模型**：Claude 4.x（默认）/ OpenAI / Gemini / 未知 → 影响结构策略
2. **输出类型**：JSON / 代码 / 散文 / 分析报告 / 其他
3. **受众与约束**：谁用、什么平台、硬限制

如果用户不回答，选最合理的默认值，在 changelog 中标明假设。

### Phase X: Self-Review（所有模式必做）

交付前跑 `references/quality-checklist.md`，修复所有 FAIL。金标准：**"一个没有上下文的同事能否无歧义地执行这个提示词？"**

### Phase X+1: Delivery（所有模式必做）

统一输出格式：
````
## Optimized Prompt
```（可直接粘贴的完整 prompt，保留所有 {{变量}}）
```

## What Changed
- 每项一个 technique + why（4–8 条，简洁）

## Mode Used
[Standard / Aristotelian / Eval-Driven] — 为何选择此模式

## Assumptions
- 仅当有未确认的假设时才列出
````

---

## Mode 1: Standard（默认）

**适用**: 一般提示词改进。最广泛最快速。

### Workflow

1. **Diagnosis** — 从草稿提取：真实意图、任务类型、目标模型、受众格式、约束、动态变量、草稿弱点。任务类型映射见 `references/technique-table.md`。

2. **Technique Selection** — 按 `references/technique-table.md` 决策表选技巧。只加真正产生价值的，不过度工程化。记下每个选择的 why → 进 changelog。

3. **Rewrite** — 按 Canonical Structure 构建。遵循 14 Golden Rules（`references/golden-rules.md`）。保留原 `{{变量}}`，负面指令转正面，非显然指令加动机。

4. **Self-Review** → `references/quality-checklist.md`

### Canonical Structure（按需省略无关节）

1. Role/persona — 一行定义
2. Task + objective — 产出物 + 成功标准
3. Context + motivation — 背景 + why
4. Data/inputs — XML 标签包裹，长上下文时数据放顶部
5. Instructions — 有序步骤，正面措辞，显式范围
6. Reasoning — 分析类任务加 `<thinking>` 块（reasoning 模型除外）
7. Examples (few-shot) — 3–5 个多样示例
8. Output contract — 精确格式（JSON schema / XML / "只输出结果"）

---

## Mode 2: Aristotelian

**适用**: 需要逻辑严密的复杂推理任务，用户要求每步决策可追溯。

**核心原则**: prompt-enhancer 本身不做 Aristotelian 推理——它产出一个**告诉目标 LLM 用第一性原理推理**的提示词。

### Workflow

1. **Gather Axioms** — AskUserQuestion 尽可能多地收集上下文：系统能力、工具、已知约束、领域事实。将已知上下文直接烘焙为 Given Axioms。

2. **Embed Reasoning Directive** — 改进后的 prompt 告诉目标 LLM：
   - 识别任务中不可约的原子真理
   - 审问每个真理（Primacy / Independence / Necessity / Consistency / Non-Contradiction 五项测试）
   - 舍弃非必要假设
   - 从真理演绎构建方案——每一步都追溯到一个具体公理
   - 最后验证结果是否符合所有公理

3. **Structure** — 输出 prompt 含五段：
   - REASONING DIRECTIVE — 告诉 LLM 从第一性原理推理
   - GIVEN AXIOMS — 烘焙的已知事实（LLM 无需猜测或幻觉）
   - TASK — 需要完成的实际任务
   - METHOD — 演绎式执行步骤
   - VERIFICATION — 对公理的最终检查

### Aristotelian 输出格式

```markdown
## Analysis
（烘焙了哪些上下文 + 为什么）

## Improved Prompt（Aristotelian Mode）
（完整的推理指令 + 给定公理 + 任务 + 方法 + 验证）

## What This Prompt Does
（总结推理行为与烘焙上下文的作用）
```

完整方法论见 `references/aristotelian.md`。

---

## Mode 3: Eval-Driven

**适用**: 有测试用例、需要迭代优化、跨模型迁移、提示词反复失败。

### Workflow

1. **Capture Contract** — 记录：任务类型（new/refine/port/debug）、目标模型、prompt surface、layer owners、目标/非目标、输入/工具/外部文件、输出格式、成功标准/失败案例、硬约束

2. **Inventory External Context** — 列出稳定的外部上下文（AGENTS.md, CLAUDE.md, specs, policies），标注 loaded/referenced/out of scope。引用文件路径而非复制内容。

3. **Choose Model Strategy** — `references/model-profiles.md`。已知模型→针对性优化。未知→可移植基础 + 适配注释。跨模型差异→仅优化差异层。

4. **Build Eval Set** — 缺少成功标准时先建小型 eval set。至少 3 个代表性用例 + 预期输出 + 失败模式。

5. **Optimize Loop**:
   - Baseline 当前 prompt 在 eval 上的表现
   - 按根因聚类失败 → 写具体编辑批评
   - 生成 2–4 个候选（minimal-diff / structure-first / examples-first / provider-adapter）
   - 在同一 eval 上比较 → 记录优化日志
   - 验证 winner 在 holdout 上的表现
   - 停止条件：平台期 / 震荡 / 过拟合 / 成本过高 / 非 prompt 瓶颈

6. **Return Package** — Target / Success Criteria / External Context / Optimized Prompt / Adapter Notes / Eval Set / Optimization Log / Residual Risks

完整方法论见 `references/eval-loop.md`。

---

## References

| 需要 | 读 |
|------|-----|
| Aristotelian 完整方法论 | `references/aristotelian.md` |
| 14 Golden Rules 详解 | `references/golden-rules.md` |
| 6-Principle Improvement Framework | `references/framework.md` |
| Common Anti-Patterns | `references/anti-patterns.md` |
| 技巧→任务决策表 | `references/technique-table.md` |
| 模型家族差异 (Claude/GPT/Gemini) | `references/model-profiles.md` |
| Eval 驱动迭代循环 | `references/eval-loop.md` |
| 质量自检清单 | `references/quality-checklist.md` |
| Before/After 示例 | `references/examples.md` |

## Boundaries

- **Improve the prompt, don't run it.** 除非用户明确说"执行这个提示词"。
- 如果草稿已经很好，只做最小改动并说明"已足够好"——不过度工程化。
- 如果瓶颈是模型选择/检索/tool schema 而非 prompt，先指出。
- 跨模型迁移时，仅优化差异层，不重写整个 prompt。
