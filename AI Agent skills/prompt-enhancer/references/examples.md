# Before/After Examples

## Example 1: Vague to Specific

**Before:**
> help me write some code

**After (given: Python, validation task):**
> Write a Python function that validates email addresses. Requirements:
> - Accept a string input, return boolean
> - Check for valid format (user@domain.tld)
> - Handle edge cases (empty string, missing @, etc.)
> - Include docstring with examples
> - No external dependencies

## Example 2: Adding Structure

**Before:**
> explain how authentication works in my app

**After:**
> Explain the authentication flow in this codebase. Include:
> 1. Entry points (login endpoints)
> 2. Token generation and validation logic
> 3. Session management approach
> 4. Key files involved with line references
> Format as a numbered walkthrough a new developer could follow.

## Example 3: Constraining Scope

**Before:**
> fix the bugs

**After (given: type errors, single file):**
> Fix the TypeScript type errors in src/components/UserForm.tsx. Constraints:
> - Only address type errors (no refactoring)
> - Preserve existing behavior
> - Use existing type definitions where available

## Example 4: Research Task

**Before:**
> tell me about kubernetes

**After (given: practical focus, intermediate audience):**
> Explain Kubernetes core concepts for a developer who knows Docker but is new
> to orchestration. Cover Pods, Services, Deployments, traffic routing, and
> basic kubectl debugging commands.

## Example 5: Creative Task

**Before:**
> write a blog post about AI

**After:**
> Write a 800-word blog post about practical AI applications in software
> development. Target: developers exploring AI tools. Include 3 examples
> with code snippets. Avoid hype. End with actionable next steps.

## Example 6: Aristotelian Mode (First Principles)

**Before:**
> deploy my app to production

**After (Aristotelian mode):**
> **Reasoning Directive:** Before taking any action, reason from first principles.
> **Given Axioms:** Root access, Node.js project, Read/Write/Bash tools available.
> **Task:** Deploy this application to production.
> **Method:** Identify atomic truths, interrogate axioms, execute deductively.
> **Verification:** Check result against every axiom.
