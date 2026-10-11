# Prompt Improvement Framework

Six principles for transforming prompts:

## 1. Clarity and Specificity

- Replace vague language with concrete terms
- Define exact output format expected
- Specify constraints, scope, boundaries
- Include examples when helpful

## 2. Task Decomposition

- Break complex requests into discrete steps
- Order steps logically with dependencies
- Identify parallel vs sequential work

## 3. Context Optimization

- Include only relevant context (remove noise)
- Front-load most important information
- Specify role/perspective to adopt
- Necessary background without over-explaining

## 4. Output Specification

- Define format explicitly (code, prose, JSON, markdown)
- Specify length/depth expectations
- Include quality criteria or acceptance standards
- Request specific structure (headers, sections, bullets)

## 5. Constraint Definition

- State what to avoid explicitly
- Define scope boundaries (what NOT to include)
- Specify technical constraints (language, framework, style)
- Set tone and audience expectations

## 6. Iteration Hooks

- Build in checkpoints for clarification
- Request reasoning/explanation when needed
- Allow for follow-up refinement

## Platform-Specific Tips

### For Claude Code / CLI
- Specify programming language and version
- Reference existing patterns in the codebase
- Include test expectations
- Define error handling requirements

### For ChatGPT / Claude.ai
- Specify depth (overview vs deep-dive)
- Request citations/sources if needed
- Define audience expertise level
- Set recency boundaries for information

### For API / Automation
- Define structured output format (JSON schema)
- Specify error handling behavior
- Include validation requirements
- Consider token limits

## 7. Aristotelian First Principles (Optional)

When the user requests "Aristotelian", "first principles", or "proof-based" mode,
the improved prompt instructs the receiving LLM to reason from first principles
during task execution. See references/aristotelian.md for the full methodology.

**Core idea:** Produce a prompt that tells the LLM to decompose the task into
atomic truths, verify them, and build its entire solution deductively from
those truths.

**What the improved prompt contains:**
1. Reasoning directive
2. Given axioms (baked-in context)
3. Axiom discovery instructions
4. Interrogation instructions
5. Deductive execution
6. Verification
