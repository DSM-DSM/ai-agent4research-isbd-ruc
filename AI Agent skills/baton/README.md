# Baton

Clean session handoffs. When you pass in-progress work to another agent — a fresh window, a future session, a different model — that runner starts with **zero of your context**. A baton is a single markdown file that lets them grab the work and sprint instead of re-deriving everything you already know.

## Core principle

Capture what the next runner **can't reconstruct** from the code or git history — your *intent*, the *dead ends you already ruled out*, and the *exact next step* — grounded in verified repo state, not your chat narrative.

There are two sides to the skill: **drop a baton** (you're handing off) and **grab a baton** (you're picking one up).

## When to use

**Drop a baton when:**
- A session ends with work unfinished and someone/something will continue it.
- The user says "hand this off", "pick up later", "pass this to another agent".
- You're running low on context and want to checkpoint before it's summarized away.
- You're about to dispatch the rest of the work to a separate agent/session.

**Grab a baton when:**
- Starting work in a repo where a prior session may have left one (check first).

**Don't use for:** a finished task (no handoff needed), or durable architecture rationale (that belongs in a long-lived design doc).

## How it works

- Batons live in **`.baton/`** at the repo root — local scratch, git-ignored, never committed.
- Filename is `<YYYY-MM-DD>-<short-slug>.md`; the next agent finds the latest with `ls -t .baton/`.
- **The iron rule — verify before you write.** A baton built from the chat story instead of repo reality is worse than none. Run `git status` and `git branch --show-current` first; the "State of play" section must reflect runtime truth, not the conversation.
- The format is a fixed set of sections — Intent & Goal, State of Play (verified against git), Learnings & Landmines, Pointers, Next Steps, Open Questions — so every handoff has a consistent, scannable shape.
- The highest-value content is the **dead ends already ruled out**: naming what *didn't* work saves the next runner a full re-derivation.

## Install

### Claude Code

```bash
git clone https://github.com/blader/baton.git ~/.claude/skills/baton
```

### Codex

```bash
git clone https://github.com/blader/baton.git ~/.codex/skills/baton
```

### One-liner (auto-detect)

```bash
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-${CODEX_SKILLS_DIR:-$HOME/.claude/skills}}" && \
git clone https://github.com/blader/baton.git "$SKILLS_DIR/baton"
```

Then restart your agent. The skill activates on handoff/resume triggers. You can also invoke it explicitly:

> Drop a baton for the next session.
> Hand this off — write a baton.
> Check for a baton and pick up where it left off.

## License

MIT
