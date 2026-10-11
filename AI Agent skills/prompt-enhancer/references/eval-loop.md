# Eval-Driven Optimization Loop

当有测试用例或需要迭代优化时使用。此方法论来自 getsentry/prompt-optimizer。

## When to Use

- 有 3+ 个代表性测试用例
- 提示词反复失败同一类任务
- 跨模型迁移
- 需要证明改进效果

## Optimization Loop

```
Baseline → Cluster Failures → Generate Candidates → Compare → Validate → Stop
```

### 1. Baseline

在当前 prompt 的同一 eval 切片上跑基准分数。记录每个用例的 pass/fail。

### 2. Cluster Failures by Root Cause

| Root Cause | Fix Strategy |
|-----------|--------------|
| Ambiguous instruction | Positive rewrite + explicit scope |
| Missing context | Add motivation / background |
| Wrong format output | Strengthen output contract |
| Model-specific behavior | Apply model-profile adapter |
| Overfitting to old examples | Replace with current diverse examples |
| Conflicting rules | Remove contradiction, single owner per rule |

### 3. Generate Candidates (2–4)

每次迭代生成精简候选集：
- **Minimal-diff repair** — 只修失败根因，保持其他不变
- **Structure-first rewrite** — 从头重组结构
- **Examples-first variant** — 调整或增加示例
- **Provider adapter** — 仅跨模型迁移时

### 4. Compare on Same Cases

所有候选在同一 eval 上比较。记录胜出者和分数差。

### 5. Validate Winner

胜出者在 holdout 用例（不在优化集中的新用例）上验证。防止过拟合。

### 6. Stop Conditions

满足任一条件即停止：
- **Platform** — 连续 2 轮无改善
- **Oscillation** — 候选在 A/B 间来回切换
- **Overfit** — eval 分数上升但 holdout 下降
- **Cost** — 优化成本超过预期收益
- **Non-prompt bottleneck** — 根因是模型能力/检索/tool schema 而非 prompt

## Optimization Log 格式

每轮记录：
```
Round N:
- Baseline score: X/N
- Root cause: [failure cluster description]
- Candidate: minimal-diff / structure-first / examples-first / provider-adapter
- Result: X/N (+Y vs baseline)
- Decision: deploy / discard / iterate
```

## Eval Set 最小规格

- 至少 3 个用例
- 每用例：输入 + 预期输出 + 失败模式描述
- 至少 1 个 holdout 用例（不参与优化，仅用于验证）
- 覆盖：正常路径 + 边界条件 + 已知失败模式
