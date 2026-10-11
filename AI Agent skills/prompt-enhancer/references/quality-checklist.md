# Quality Self-Review Checklist

Phase 4 自检清单。交付前逐项通过。金标准：**"一个没有上下文的同事能否无歧义地执行这个提示词？"**

## Structure

- [ ] Canonical structure 各节按需启用，无缺失必要节
- [ ] XML 标签一致、描述性、无嵌套混乱
- [ ] 长数据在前、指令在后（>20k tokens 时）
- [ ] 动态变量用 `{{双大括号}}`，最好包在 XML 中

## Instructions

- [ ] 正面措辞（"做 X"而非"不要做 Y"）
- [ ] 有序步骤（顺序重要时标号）
- [ ] 显式范围（Claude 4.x："对所有章节"而非"对章节"）
- [ ] 每条规则有单一 owner，无跨层重复
- [ ] 无模糊指向（"看文档"→ 改成引用具体文件路径）
- [ ] 无心理技巧（"这很重要"、"深呼吸" 等 null/negative）

## Context

- [ ] 非显然指令有动机（why 解释）
- [ ] 背景信息精简，去噪音
- [ ] 外部上下文明确 loaded / referenced / out of scope
- [ ] Persona 仅当改变行为时存在，且轻量

## Examples

- [ ] 3–5 个多样化示例（若任务需要格式/语气一致性）
- [ ] 示例格式与实际输出合同一致
- [ ] 无死示例（不能改善 eval 的示例 → 移除）
- [ ] 示例展示 input → reasoning → output 完整链路

## Output Contract

- [ ] 精确格式定义（JSON schema / "只输出结果" / 具体结构）
- [ ] 成功标准定义（什么算好答案）
- [ ] 硬约束声明（长度/语气/禁止项 — 用正面措辞）
- [ ] 研究/分析类任务有跨源验证要求

## Model Awareness

- [ ] Reasoning 模型中无 "think step by step"
- [ ] Claude 4.6+ 无 prefill 依赖
- [ ] 跨模型迁移时有 adapter notes

## Anti-Overengineering

- [ ] 简单 prompt 未过度扩展（无不需要的 CoT/示例/multi-section）
- [ ] 重型技术（ensembling/tree search）仅在关键性足够时启用
- [ ] 如果草稿已足够好 → 最小改动 + 说明"已足够好"

## Security（若处理不可信输入）

- [ ] 不可信数据用分隔符包裹
- [ ] 指令优先级声明
- [ ] 工具策略在 prompt 正文，schema 在 provider-native tools
