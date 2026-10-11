# Model Family Profiles

跨模型差异速查。未知模型→可移植基础 + 适配注释。

## Claude 4.x (Default)

| Dimension | Strategy |
|-----------|----------|
| **Structure** | XML 标签 + canonical structure 全启用 |
| **Scope** | 极度字面主义 — 必须显式声明范围（"对所有章节"而非"对章节"） |
| **Reasoning** | 支持 `<thinking>` 块，分析任务加 CoT |
| **Output** | output contract / structured outputs，不支持 prefill |
| **Persona** | 轻量 — 仅当改变行为时使用 |
| **Length** | 最短措辞保留约束 |

## OpenAI GPT / o-series

| Dimension | Strategy |
|-----------|----------|
| **Reasoning models (o-series, GPT-5 reasoning)** | **不要** "think step by step" / CoT — 被忽略或反效果。给高层目标+约束+输出合同 |
| **Non-reasoning GPT** | 可用 CoT，结构用 Markdown 而非 XML |
| **Output** | JSON mode / structured outputs 可用 |
| **Style** | 提示词用 markdown→输出倾向 markdown；要去掉则提示词也去掉 |
| **Contradictions** | 对内部矛盾敏感 — 检查重复规则是否冲突 |

## Gemini

| Dimension | Strategy |
|-----------|----------|
| **Structure** | 混合 XML/Markdown 均可 |
| **Examples** | 尤其重要 — Gemini 从示例中泛化效果显著 |
| **Safety** | 更保守的内容过滤，明确声明内容边界 |
| **Length** | 对极长 prompt 的中间信息容易遗忘 — 关键约束放开头和结尾 |

## Cross-Family Porting

跨模型迁移时：
1. 先在目标模型上跑 baseline eval
2. 仅改差异层（通常是 instructions 措辞和 output schema 格式）
3. 不要重写整个 prompt — 策略性只修不通过 eval 的部分
4. 记录 adapter notes（改了什么、为什么）
