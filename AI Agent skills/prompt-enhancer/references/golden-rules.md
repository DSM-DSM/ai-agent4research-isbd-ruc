# 14 Golden Rules（14 条黄金法则）

提炼自 Anthropic 官方提示工程指南、OpenAI GPT-5 指南、Google Gemini PTCF、The Prompt Report。

1. **Explicit clarity（显式清晰）.** 把模型当作有才华但没有你项目上下文的新同事。明确指定格式和约束。

2. **Positive > negative（正面 > 负面）.** "用流畅散文书写" 优于 "不要用 markdown"。正面示例 > 禁止清单。

3. **Context and motivation（上下文与动机）.** 解释指令背后的 why——模型从原因中泛化得更好。

4. **Explicit scope — Claude 4.x（显式范围）.** Claude 4.x 是字面主义者；它不会推断你没有明确要求的范围。声明"适用于所有章节，不仅是第一章"。

5. **Outcome over steps — reasoning models（结果优于步骤）.** GPT-5/o-series 在目标+约束+输出合同的指导下表现更好，避免微管理中间步骤。不要对 reasoning 模型使用"think step by step"。

6. **XML to structure（XML 结构化）.** 一致、描述性的标签分离指令、上下文、数据和示例。有层级嵌套时用嵌套标签。

7. **Examples are the strongest lever（示例是最强杠杆）.** 对格式/语气/一致性的改善最有效。3–5 个多样化示例，放在 `<example>` 标签中。

8. **CoT for reasoning（推理任务用思维链）.** 分析任务先要求推理再给答案——但将推理（`<thinking>`）与最终输出（`<answer>`）分离。

9. **Match style（风格匹配）.** 提示词的风格影响输出的风格。要无 markdown 输出→用无 markdown 的提示词。动态变量用 `{{双大括号}}`，最好包在 XML 中。

10. **Success criteria（成功标准）.** 定义什么算好答案。研究/分析任务中要求跨源验证和竞争假设。

11. **No prefill in Claude 4.6+（无预填充）.** Claude 4.6+ 不再支持 assistant 最后一条消息的预填充；使用 output contract / structured outputs。

12. **Structure > psychological tricks（结构 > 心理技巧）.** "this is important to me"、"take a deep breath" 等在旧模型中曾有效果，但在 Claude 4.x / GPT-5 中是 null 或负面的。用结构解决，不用技巧。

13. **Security with untrusted input（不可信输入的安全）.** 如果 prompt 处理用户/web/文档文本或以 agent+tool 模式运行，用分隔符包裹数据并声明指令优先级。

14. **Cost of heavy techniques（重型技术的成本）.** Ensembling（self-consistency, DiVeRSe）和 tree search（Tree-of-Thoughts, maieutic）消耗 N× token。仅在关键性足够高时使用。
