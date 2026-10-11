---
name: baton
description: Use when handing off in-progress work to another agent or future session — unfinished work, "pick up where I left off", running low on context, or persisting intent before context is lost. Also use when .baton/ holds many handoff files to merge/consolidate ("整理 .baton 目录", "merge/consolidate batons"), or when reconstructing a handoff from a session that died before dropping one ("上一个会话死了/中断了", "把历史对话总结成 baton", "从 transcript 提取脉络补落 baton"). Covers drop, grab, transcript-recovery, merge.
metadata:
  provenance: self-improving-skills

---
# Baton

## Overview

A relay only works if the baton is passed cleanly. When you hand work to another
agent — a fresh window, a future session, a different model — that runner starts
with **zero of your context**. A baton is a single markdown file that lets them
grab the work and sprint, instead of re-deriving everything you already know.

**Core principle:** capture what the next runner can't reconstruct from the code
or git history — your *intent*, the *dead ends you already ruled out*, and the
*exact next step* — grounded in verified repo state, not your chat narrative.

Three sides to this skill: **Drop a baton** (you're handing off), **Grab a
baton** (you're picking one up), and **Merge batons** (you're consolidating a
pile of stale handoffs into a few independent ones).

## When to Use

**Drop a baton when:**
- A session ends with work unfinished and someone/something will continue it.
- The user says "hand this off", "pick up later", "pass this to another agent".
- You're running low on context and want to checkpoint before it's summarized away.
- You're about to dispatch the rest of the work to a separate agent/session.

**Grab a baton when:**
- Starting work in a repo where a prior session may have left one (check first).

**Merge batons when:**
- `.baton/` has accumulated many handoff files (10+) and the user asks to
  "融合/合并接力棒" or "整理 .baton 目录" — collapse them into a few mutually-independent batons.

**Don't use for:** a finished task (no handoff needed), or durable architecture
rationale (that belongs in a long-lived design doc, not a baton).

## Where the Baton Lives

Default destination: **`.baton/`** at the repo root — a dedicated folder for
handoffs, created if it doesn't exist. It works in any repo, so there's no other
location to choose.

`.baton/` is local scratch, not committed. The first time you drop a baton,
ensure it's git-ignored — if `.gitignore` doesn't already cover it, add a
`.baton/` line.

Filename: **`<YYYY-MM-DD>-<short-slug>.md`**
(e.g. `.baton/2026-06-13-formula-eval-rounding.md`).

The next agent finds the latest with `ls -t .baton/`.

Merged/consolidated batons stay in the same `.baton/` dir and end in `-mer`:
`<YYYY-MM-DD>-<theme>-mer.md` (e.g. `2026-08-11-experiment-directions-progress-mer.md`).

## The Iron Rule: Verify Before You Write

A baton built from the chat story instead of repo reality is worse than none —
it sends the next runner the wrong way with false confidence. Before writing,
run `git status` and `git branch --show-current` and confirm what is *actually*
committed vs. uncommitted. The "State of play" section must reflect runtime
truth. If reality contradicts the narrative, **the baton documents reality** and
flags the gap.

Push/remote sentences get the same treatment — probe, never assume. Run
`git remote -v` and `git rev-parse --abbrev-ref --symbolic-full-name @{u}`
before writing "未推送 / not pushed" (or "已推送"). A repo may have **no remote
at all** — then the claim is not merely unverified, it is meaningless; write
"仓库无 remote，提交即终态". (2026-10-03: baton first drafted "均未推送（本地
master 领先）"; the probe returned an empty `git remote -v` + `fatal: no upstream
configured` — corrected to no-remote wording.)

`git status` verifies the *repo* — it says nothing about *servers* or what
parallel sessions have in flight. Before dropping, also cross-check sibling
batons: see "Before You Drop: Cross-Check Sibling Batons" below.

## Before You Drop: Cross-Check Sibling Batons (落棒前交叉核查同胞棒)

Sibling batons in `.baton/` are the written record of what concurrent sessions
left queued or running. Skipping them means your new baton can contradict
reality on day one (2026-09-04 M20/M18 westd 实战).

**症状:** the new baton's draft asserted "westd 已无任务、记得人工关机止损" —
while a sibling baton (`2026-09-03-m18-six-arms-submitted-after-m20.md`) opened
with "M18 六臂已提交 westd（wrapper 等 M20 五臂跑完自动接力，预计 09-04 深夜跑
完）". Executing that shutdown would have killed six queued training arms.

**根因:** the drafting session verified only `git status` and its own memory —
it never cross-checked the other concurrent session's baton for server
occupancy or overlapping direction.

**取证 (before every drop):**
1. `ls -t .baton/`, then `head` the TL;DR of each recent sibling — the M18
   baton's *first sentence alone* was enough to catch the collision. Check two
   things:
   - **Server occupancy / queue records by other sessions** — their tasks may
     depend on `.no_shutdown` or relay wrappers; your "idle" is their "running".
     Shutdown / kill / submit decisions must wait until `ps` + log `tail`
     confirm the server is actually free.
   - **Whether the same direction is already being pushed by another session** —
     two sessions on one server, or writing the same output dirs, collide.
2. If a sibling's claim affects your next steps and is within your session's
   reach, read that sibling's full text before acting on the TL;DR.

**预防:** if this reveals an earlier claim (yours or another session's) is
wrong, supersede it **explicitly in the new baton** — "该说法作废 + 原因" —
never just silently write the corrected version; the next runner may have read
the old claim elsewhere.

Timing note: this is the **drop-side** mirror of "Grabbing a Baton" items 5/6.
Items 5/6 handle sibling claims *when you pick a baton up* (verify live-system
assertions; coexist with the session that owns them). This section runs *before
you write yours* — same evidence source, different action point. Do both.

## Baton Format

Fill every section. If one is genuinely empty, write "none" — don't delete it
(the next runner relies on the shape being consistent).

```markdown
# Baton: <one-line title of the work>

**TL;DR:** <1–3 sentences: what this is, where it stands, the single next action.>

## Intent & Goal
Why this work exists and the desired end state. Include the acceptance
criteria — ideally the exact command/test that must go green.

## State of Play (verified against git)
- Branch: <branch> — confirmed via `git branch --show-current`
- Committed: <what's landed>
- Uncommitted / in flight: <what's in the working tree, from `git status`>
- Verified working: <what you've actually run and confirmed>
- Assumed / unverified: <what you believe but haven't proven>

## Learnings & Landmines
The highest-value section — what the next runner can't get from the code:
- Non-obvious discoveries.
- **Dead ends already ruled out** (so they don't repeat them) and *why*.
- **Do NOT touch** zones and the reason.

## Pointers
- Key anchors: `path/to/file.ts:123` — what's there.
- Relevant docs / prior batons / PRs.
- Commands to get oriented or reproduce: `<cmd>`.

## Next Steps
Ordered, concrete, immediate action first. Not "finish the feature" — the
literal next move.

## Open Questions
Unresolved decisions + your current lean (so they can proceed if no one answers).
```

## Grabbing a Baton (resuming)

1. **Find it:** `ls -t .baton/` — read the newest.
   **⚠️ 合并整理后的目录（2026-09-23 实证）**：`-mer.md` 合并完成后原单棒可能已被移入 `.baton/archive/`——按旧文件名直接 open 会落空（"No such file"）。正解：`ls .baton/ .baton/archive/` 双层看；抓棒 = 读最新 `-mer.md` 里自己方向的相关段落（`grep -n "方向名\|关键词" *.mer.md` 定位，别只看 TL;DR）；落棒 = 新棒与 `-mer` 并存（不编辑 -mer 原文），若完成了 -mer 里记录的待办，在新棒中**显式作废该条 + 指回 -mer 文件名**，下一轮合并时据此折叠。
2. **Trust but verify:** re-check "State of play" against real `git status` before
   acting; the repo may have moved since the baton was dropped. When the next
   action is "commit this batch", diff the *content* too — `git diff -- <file>`
   for each listed file must match the baton's description of the changes (the
   tree can hold extra or missing edits a file list alone won't reveal).
   (2026-10-03: the six `main.tex` formula fixes were diff-verified against the
   baton before committing.)
3. **Continue** from Next Steps.
4. **Retire it** when the work lands: delete it if it was only scratch, or fold
   durable learnings into a canonical doc and then delete. Don't let stale batons
   pile up in `.baton/`. If only *some* items landed and the rest is still live,
   update it in place instead: strike the finished item
   (`~~原文~~ **已完成（日期）：结果 + commit hash**`), backfill State of
   Play / Next Steps / TL;DR with the outcome, and fix any **memory** claim the
   completion supersedes — the memory file *and* its `MEMORY.md` index line, since
   memory is read before any baton. A stale "尚未提交（等用户发话）" misleads the
   next session exactly like a stale baton. (2026-10-03: the last open item
   "问作者：这批改动是否提交" resolved into `9bc3ff7`/`649ccfd`; baton + memory
   were backfilled in the same session.)
5. **Live-system assertions in the newest baton can be wrong too** (2026-09-04 实战):
   the writing session may never have verified them — one baton claimed "server has
   no tasks left, remember to shut it down" while a six-arm training chain was still
   running; blindly following it would have killed the chain. Beyond the
   `git status` check, treat every baton claim about servers/processes/shutdown
   flags as unverified until you re-check read-only: running jobs (`ps`/`pgrep`) +
   the flag file (`ls .no_shutdown`) + `tail` the logs — three checks, then act.
   The drop-side mirror (cross-check sibling batons *before writing yours*) is
   "Before You Drop: Cross-Check Sibling Batons".
6. **Concurrent-session coexistence** (2026-09-04 实战): while you grab, another
   session may be live-editing the same baton and operating the same server (one
   session shipped two upgrades, v3→v4, within 3 minutes of the check). Rules:
   append your own findings as a **timestamped addendum block** — never rewrite the
   other session's paragraphs; if their record is wrong, mark it superseded
   (作废 + reason) **inside your own addendum** with a pointer back to it, so both
   the other session and the next runner see the correction. Prefer read-only
   verification; leave server mutations (kill/submit/shutdown) to the session that
   holds operation rights — the baton file itself is the coordination channel.
7. **Post-migration repo + dead session-level cron: re-verify the runtime scene before working** (2026-09-28 D:\MDS-ED→F:\MDS-ED 实证). Two grab-time traps the baton text alone can't fix:
   - **Drive migration ⇒ cwd drift + thinner copy + split downloads.** After a repo
     moves drives, each command's cwd may be the repo root *or* a subdirectory, so
     relative-path reads/downloads land on the wrong root (12 arms' artifacts were
     pulled to `<repo>/outputs/` while the convention is `src/outputs/runs/`; a
     "missing `.gitignore`" was a cwd illusion). The migrated copy can also lack
     dirs/dotfiles (archive policy excluded big artifacts). Fix: pin the root once
     after grabbing (`pwd` + `git rev-parse --show-toplevel`) and re-derive every
     relative path from it. Then run a **dual-location merge audit**: the old
     session's cron may have already pulled some arms to the *canonical* location
     while your new downloads went to the wrong one — merge per-arm by artifact
     completeness (canonical complete → delete the wrong-root copy; canonical
     incomplete → replace with the complete wrong-root copy). Never assume "one
     side is all correct".
   - **A session-level cron is not part of the handoff.** The baton said "cron
     7a0aa2a8（本会话级）每 17 分钟托管中" — session-level crons die with their
     session, so `CronList` in the new session is empty ⇒ the patrol already
     lapsed and a backlog accumulated during the gap (12 arms here). Takeover
     order: `CronList` (confirm dead) → SSH the server for *actual* progress (it
     may be ahead of what the baton recorded) → manually run one catch-up
     download pass for the backlog → recreate an equivalent cron (new id) → note
     "已接管旧棒巡检" in your report. Rule of thumb: a baton that mentions a cron
     = rebuild the patrol before doing the work.

## Reconstructing a Baton from a Dead Session (从已死会话补落 baton)

When a session dies before dropping its own baton — API interrupt, model switch,
crash — the user may ask you to summarize it on its behalf ("上一个会话死了/中断了，
帮我把历史对话总结成 baton"). The source of truth is that session's **transcript
JSONL**, not the code (code only shows the end state, never the intent or dead ends).

**Find the transcript:** `~/.claude/projects/<project-slug>/<session-id>.jsonl`.
`<project-slug>` is the working-directory path with the drive-colon and path
separators turned into `-` (e.g. `D:\HuaweiProject\Anomaly_LowFreq` →
`D--HuaweiProject-Anomaly-LowFreq`). The session id comes from the user, or from
memory's `originSessionId`.

**Parse it — do NOT `Read` it.** Transcripts can be 8MB+; a raw Read blows context.
Stream-parse each line with `json.loads` and print only the slices you need:

```python
import json
rows = []
with open(r"~/.claude/projects/<slug>/<session-id>.jsonl", encoding="utf-8") as f:
    for ln in f:
        rows.append(json.loads(ln))

# real user turns (skip tool-result echoes and system-injected strings)
for o in rows:
    if o.get("type") != "user" or o.get("isSidechain"):
        continue
    c = o.get("message", {}).get("content")
    if isinstance(c, str):   # "Stop hook feedback" / "<task-notification>" — not a real prompt
        continue
    txt = [b for b in c if b.get("type") == "text" and b.get("text", "").strip()]
    tr  = [b for b in c if b.get("type") == "tool_result"]
    if txt and not tr:
        print("USER:", txt[0]["text"][:200])

# assistant replies (skip thinking)
for o in rows:
    if o.get("type") != "assistant":
        continue
    for b in o.get("message", {}).get("content", []):
        if b.get("type") == "text":
            print("ASSISTANT:", b["text"][:200])
```

**Top-level `type` field discriminates rows:**
- `user` — user input; `message.content` is a list of `text` / `tool_result` blocks,
  **or a plain string** (system-injected: "Stop hook feedback", "<task-notification>") — skip strings.
- `assistant` — reply + tool calls; `message.content` list of `text` (reply) /
  `thinking` / `tool_use`.
- `system` — hook summary; `mode` / `last-prompt` / `queue-operation` are per-loop
  metadata; `attachment` / `file-history-snapshot` / `file-history-delta` are tool
  artifacts — ignore.

**Filtering rules:**
- Real user input = `type=="user"` **and** `isSidechain != True` (skip subagent
  sidechain / tool-confirm rows) **and** `content` is a list with a non-empty
  `text` block **and no `tool_result` block** (a `tool_result` row is a tool echo,
  not a user turn).
- Real assistant reply = `type=="assistant"` with a `text` block (skip `thinking`).

**Find why it died:** read the **last few** assistant `text` blocks. An
`API Error: 400 ... tool use concurrency` tail means the session crashed mid-tool-use
and never dropped a baton — exactly the gap you're filling.

**Highest-yield slice = the `tool_use` stream, not just user/asst prose.** Add a third
parser mode that prints every assistant `tool_use` as `name + key args` (`file_path`
for Write/Edit, the command for Bash, `pattern`/`path` for Grep/Glob). This one slice
reconstructs *what the session actually did* — the file list, the literal last
command, the dead-end detours — far better than the reply text, and it shows the
session's own tooling (`Skill`/`Agent` calls reveal which skills were loaded and what
was distilled). Read the prose for intent, the tool_use stream for state.

**Confirm the death cause from the row, not the prose:** a synthetic API-death row
carries `"model": "<synthetic>"`, `isApiErrorMessage: true`, `apiErrorStatus: 400`.
A `cost-state` row at the tail gives `totalCostUSD` / `totalDuration` if you want to
report how large the session was.

**Adjudicate ownership by transcript grep, not by date.** When `git status` shows
uncommitted work — or `git log` shows commits inside the dead session's time window —
grep the transcript's `tool_use` inputs for the artifact name / commit hash:
**0 hits ⇒ it is NOT this session's work** (a concurrent session's). Dates are
ambiguous when sessions overlap or a file was merely touched; tool_use evidence is
decisive. Record the verdict in State of play as "not ours — do not touch", and note
that a commit batch then carries mixed provenance.

**Resolve the blocking fact before writing Next Steps.** A baton reconstructed from a
dying session usually stops one step short of a *specific unverified fact* (a wrong
path, a missing value) the session was mid-way through checking. If it is reachable
read-only, resolve and verify it now: the next runner's step 1 then becomes
copy-paste executable instead of "figure out the right X". (M26 案例: an arm's preds
directory was mis-mapped — grepping the sibling analysis scripts for the authoritative
mapping, then running the check, turned a blocker into a one-line diff.)

**Fix stale *memory* too, not just sibling batons.** Memory files are loaded into
every future session's context and are read *before* any baton — so a superseded
claim there misleads earlier and harder than a stale baton does. After
reconstructing, grep the memory dir for the same assertion (typically a decision the
dead session's *later* turns overturned), correct it in place, and add the supersede
table to the baton.

**Then obey the Iron Rule as usual.** The transcript yields the *narrative* (intent,
dead ends, next step), but "State of play" must still come from a live `git status` +
`git branch --show-current` — the repo may have moved since the session died.
Reconstruct intent from the transcript, reality from git.

## Merging / Consolidating Batons (融合接力棒)

When `.baton/` accumulates many handoff files, merge them into a few
mutually-independent batons so the next runner isn't facing 13 files deep. Do
this proactively before the folder becomes an unreadable pile.

**Workflow:**

1. **Pre-filter with a theme-keyword grep, then read the hits full-text** —
   start with one `Grep` over `.baton/` for the topic's keywords
   (e.g. `html|模板|template|slide|lecture|讲演|演示|网页|deck`); read only the
   hits plus anything adjacent instead of every file. This narrowed 12
   candidates to 4 before the first full read. Still don't classify by filename
   alone: one file may cover several directions, and the newest may only be a
   summary of older ones (a session found 14 files but a quick `ls` missed one
   until a re-scan).
   **Grep hit ≠ theme match — confirm with a full read.** A keyword hit can be
   incidental (a Git-collaboration baton hit "网页" only because it mentioned
   "网页端操作/GitHub Pages", and was unrelated to webpage templates). Read each
   hit's full text before including or excluding it; grep only narrows the
   candidate set.
2. **Classify by theme, but check for one-continuous-timeline groups first.**
   Before splitting apparent sub-themes into separate files, ask: do these files
   trace one pipeline's consecutive evolution — the same code files referenced,
   each newer one citing the previous as "之前 baton", mtimes in
   near-continuous sequence? If so it's ONE direction (8 incremental files on
   device_split / source 池 / 输出 / 诊断 were one timeline) → merge into a
   single `-mer.md` with internal sub-sections plus a per-sub-topic
   quick-reference table, not many files. Reserve separate merged files for
   genuinely independent themes (HBCE / M4 / HMLC), webpage/week-report, and a
   catch-all for the rest (meeting/direction docs). Name each output
   `<YYYY-MM-DD>-<theme>-mer.md` in the same `.baton/` dir.
3. **Verify real write-time, not just the filename date** — filenames can lie.
   A file named `2026-07-24-hbce-phase1-complete.md` was actually rewritten
   07-31 (mtime 07-31 10:19), the same minute as the "newer" file it
   contradicted. Cross-check `ls -la --time-style=long-iso` mtimes against
   filename dates before trusting "later wins". A filename date far *older* than
   its mtime (named 08-09, mtime 08-17) flags the file as a rewritten snapshot —
   often a stale one the yet-newer file supersedes. Order the merged file's
   「融合来源」 list by real mtime, not filename date.
4. **Verify commit references before asserting "landed on master".** When a
   baton cites a commit (`最后提交 7bc3aae`) or claims a merge to master, run
   `git log --oneline --all | grep <hash>` to confirm each cited hash actually
   exists in history before writing the claim into the merged State of Play.
   (For the batch version — which also catches *mis-cited* hashes — see
   `references/repeat-merge.md`.)
5. **Resolve conflicts by the reference + fact chain, not blind "latest date".**
   When two batons for the same direction contradict (one says "complete", the
   other "pending run"), pick the side the *other* batons corroborate — a later
   week-report baton explicitly citing "24 groups finished", or all subsequent
   batons assuming it done — and record the reasoning in the merged file's
   「冲突处理记录」 block so it can be re-audited.
6. **Keep all information, not just the winning side.** Keep the winning state
   as the current picture, but preserve the loser's code details / run commands
   as process history. When a later finding invalidates an earlier conclusion,
   don't delete it — mark it 「存疑/待验证」 (e.g. M6 D1: mask never activated,
   so the earlier "tree direction disproved" numbers are void until rerun). For
   a metric that evolved along a single timeline (test counts
   24→26→24→28→29→29→30), record the full evolution chain in the conflict record
   and take the latest as current — never silently drop the old values.
7. **Never delete the originals.** Merging *adds* `-mer.md` files; leave the
   sources untouched (the user deletes them later if they want). Each merged
   file opens with a 「融合来源 + 冲突处理记录」 block and typically ends with a
   per-direction status quick-reference table.

8. **Repeat merge (a `-mer.md` already exists)? Load `references/repeat-merge.md`
   first.** A second merge is a different job: baton-recorded commit status has
   often already landed (re-derive from git per path), direction docs may hold
   verdicts newer than the batons describe, cited commits need batch verification,
   intra-baton contradictions can't be arbitrated by date, and concurrent sessions
   drop new batons while you work. The reference carries steps 8–15 of this
   workflow (repeat-merge discipline) plus its own Common Mistakes table.

## Reference Files

Extensible index — future extensions of this skill land here as separate
reference files; add a row below when adding one.

| File | Read when |
|------|-----------|
| `references/repeat-merge.md` | Merging a `.baton/` folder that has been merged before (any `-mer.md` exists) — steps 8–15 of the merge workflow + its own Common Mistakes table. |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Baton restates the diff | The diff is already in git. Capture intent, dead ends, next step. |
| Built from chat, not `git status` | Verify first — a confidently-wrong baton is worse than none. |
| Vague next step ("continue the work") | Write the literal next action. |
| Dead ends omitted | Naming what *didn't* work is the highest-value content — it saves a full re-derivation. |
| Scattered handoff location | Always `.baton/` at repo root — never elsewhere, or the next agent can't find it. |
| Stale batons pile up | Retire it when the work lands: delete, or fold learnings into a canonical doc. |
| Filename date trusted over real mtime | A file dated `07-24` may have been rewritten `07-31`. Cross-check `ls -la --time-style=long-iso` mtimes before "later wins". |
| Contradicting batons resolved by filename date alone | Corroborate the "later" side against what other batons reference/cite, and record the reasoning — don't blindly trust the later filename. |
| Grep hit treated as a theme match | Grep only narrows candidates — a keyword hit can be incidental (a Git baton hit "网页" via "网页端操作/GitHub Pages"). Read each hit's full text to confirm the theme. |
| One continuous timeline split into many merged files | If each file cites the previous as "之前 baton" and references the same code, it's one direction — merge into one `-mer.md` with sub-sections, not many. |
| Commit references taken on faith | `git log --oneline --all | grep <hash>` each cited commit before asserting "landed on master" in the merged State of Play. |
| Merging deletes the originals | Merging only *adds* `-mer.md` files. Leave the source batons untouched; the user deletes them later if they want. |
| Drop written from `git status` + own memory only, sibling batons unread | Before dropping, `ls -t .baton/` + `head` recent siblings' TL;DRs: a sibling may record another session's queued tasks (your "idle server, shut it down" is their "running, don't kill") or same-direction work heading for a collision. If you find an old claim is wrong, supersede it in the new baton (该说法作废 + 原因). (2026-09-04 M20/M18 westd) |
| Reconstructed baton treats every uncommitted file / recent commit as the dead session's | Grep the transcript's `tool_use` inputs for the artifact name / commit hash — **0 hits ⇒ concurrent session's work**. Mark those "not ours — do not touch" in State of play instead of bundling them into the next-step plan. (2026-09-24 `44ca3c32`) |
| Superseded claim left in memory after the reconstruction | Memory is read *before* batons in every future session — grep the memory dir for the overturned assertion and fix it in place, not just the baton. (2026-09-24: memory still said "MoE 不入稿" while the manuscript already contained MoE) |
| Transcribed the narrative without resolving the fact the session died mid-check | Read-only resolve the one blocking fact (wrong path / missing value) before writing Next Steps, so step 1 is copy-paste executable rather than a rediscovery. (2026-09-24: verified the correct preds dir + its metric) |
| Connection strings / host-key fingerprints / tokens in a baton typed from memory | A single-character slip burns the next runner's time — or silently points at the wrong host. Copy-paste such literals from a recently *successful* invocation (the shell command that just worked, or the sibling baton/script that owns them) — never re-type; then mechanically re-read every literal in the Pointers section against its source. (2026-09-26: one host-key fingerprint mistyped twice in live commands, and a third time when transcribed into the baton) |
| Grabbed a baton written before a repo drive migration / with a live session-level cron, and trusted its paths + the patrol | Re-pin the repo root (`pwd` + `git rev-parse --show-toplevel`) and re-derive every relative path; merge split downloads by per-arm artifact completeness (never assume one side is all correct); treat a mentioned cron as dead (`CronList` empty = patrol lapsed) — rebuild it before working. (2026-09-28 D:→F: 迁移 + 12 臂下载错位 + 巡检断档) |
| Baton asserts "未推送 / not pushed" without probing the remote | `git remote -v` + upstream query first — a repo may have no remote at all, making push-state wording meaningless; then write "仓库无 remote，提交即终态". (2026-10-03) |
| Finished a baton item but left the baton + memory still saying "pending" | Backfill in place: strike the item with outcome + commit hash, refresh State of Play / Next Steps / TL;DR, and fix the memory file + its `MEMORY.md` index line. Memory is read before batons, so a stale claim there misleads first. (2026-10-03) |

## Response Behavior

After dropping a baton, state the exact path written and a one-line summary of
what's in it.
