# Technique → Task Decision Table

选择技巧时对照此表。只选真正产生价值的，不过度工程化。

| Task type | Core techniques | Notes |
|-----------|----------------|------|
| **Classification** | Role, XML inputs, diverse few-shot, short CoT, enum output | 3–5 个多样化示例决定一致性 |
| **Structured extraction** | Role, XML, output schema (JSON), grounding by quotes | 显式 JSON schema 优于文字描述格式 |
| **Generation/writing** | Role, persona+audience, tone examples, format, constraints | 用示例展示语气，不只描述 |
| **Coding** | Clear objective, constraints, explicit scope, anti-overengineering, output contract | Claude 4.x 对显式范围尤其敏感 |
| **Reasoning/analysis** | CoT（非 reasoning 模型）/ high-level goal（reasoning 模型）, self-check | Least-to-Most 或 Tree-of-Thoughts 用于困难问题 |
| **Research** | Success criteria, competing hypotheses, multi-source verification, decomposition | 要求引用溯源 |
| **Agentic/tool-use** | Explicit action instruction, ReAct, parallel tool calls, context engineering | 工具策略写在 prompt 正文，schema 放在 provider-native tools |
| **Summarization/transformation** | Long-context layout（数据顶部）, grounding, output contract（长度） | 长上下文规则：数据在前，指令在后 |

## Technique Selection Rules

1. **Don't inflate simple prompts.** 分类/格式化 → 精简结构改写，不加 CoT/示例。
2. **Calibrate to complexity.** 复杂推理/agentic → 完整结构。不过度工程化。
3. **Model-aware.** reasoning 模型不加 "think step by step"。
4. **CoT when analysis needed.** 分析类任务要求推理块在答案之前，但两者分离。
5. **2–3 examples minimum for format/tone.** 示例是格式一致性的最强杠杆。
