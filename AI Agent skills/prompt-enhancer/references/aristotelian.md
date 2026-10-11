# Aristotelian First Principles Mode

A prompt design methodology that instructs the **receiving LLM** to reason from first principles when executing a task. Rooted in Aristotle's *Posterior Analytics*.

## Core Concept

The prompt-improver does NOT perform Aristotelian reasoning itself. Instead, it produces an **improved prompt that tells the LLM to use Aristotelian reasoning on the task**. The output prompt instructs the AI to:

1. Identify the atomic, irreducible truths relevant to the task
2. Interrogate those truths to confirm they are genuinely foundational
3. Build its entire solution deductively from those verified foundations
4. Trace every decision back to a specific axiom

## How the Prompt-Improver Prepares the Prompt

Before generating the Aristotelian prompt, the improver gathers context to bake into it:

**Context to embed in the prompt:**
- Known system capabilities (e.g., root/sudo access, OS, installed tools)
- AI model being used and its strengths
- Available tools and integrations the LLM can call
- Domain constraints from the user (language, framework, project conventions)

This context becomes the **given truths** the LLM will use as its starting axioms.

## The Aristotelian Prompt Structure

### Part 1: Reasoning Directive

Tell the LLM to work from first principles:
``
Before taking any action, reason from first principles. Identify the fundamental,
irreducible truths relevant to this task. Do not assume anything that cannot be
traced back to a verified ground truth. Build your approach step by step, where
each step is justified by either a foundational truth or a prior verified step.
``

### Part 2: Given Axioms (Baked-In Context)

Provide the known truths so the LLM does not have to guess or hallucinate them.

### Part 3: Axiom Discovery Instruction

Tell the LLM to find additional axioms specific to the task before acting.

### Part 4: Axiom Interrogation Instruction

Tell the LLM to verify its own axioms before building on them.

### Part 5: Deductive Task Execution

Tell the LLM to execute the task as a logical proof, tracing each action to an axiom.

## Verification Tests for Axioms

| Test | The LLM asks itself | Action if fails |
|------|---------------------|-----------------|
| **Primacy** | "Can this be derived from something more basic?" | Decompose further |
| **Independence** | "Does this depend on another axiom?" | Mark the dependency chain |
| **Necessity** | "If I remove this, does the task become impossible?" | Keep only if yes |
| **Consistency** | "Does this contradict anything else I hold true?" | Resolve the contradiction |
| **Non-Contradiction** | "Am I assuming X and not-X simultaneously?" | Eliminate one |

## Key Aristotelian Principles

1. **Non-Contradiction**: The LLM must not hold two contradictory premises simultaneously
2. **Excluded Middle**: Each claim about the task is either true or false
3. **Sufficient Reason**: Every action in the solution must trace to a stated axiom
4. **Causal Priority**: The LLM should explain *why* it does something, not just *what* it does

## Why This Works for LLMs

- **Reduces hallucination**: The LLM is explicitly told to only build on stated truths
- **Improves chain-of-thought**: Each deductive step is a natural reasoning unit
- **Enables self-correction**: The LLM has reference points to catch errors
- **Structures attention**: The hierarchical structure helps the model focus
- **Prevents drift**: Axioms anchor the reasoning to the specific task

## When to Use This Mode

- Tasks where precision and correctness matter more than speed
- Complex multi-step work where a wrong foundation cascades into failure
- When the user wants the LLM to show its reasoning and justify every decision
- When the user explicitly says "Aristotelian", "first principles", or "proof-based"

## When NOT to Use This Mode

- Simple prompt improvements (use the standard framework)
- Creative/open-ended tasks where rigid logical structure over-constrains
- Quick mode requests
