# Repeat-Merge Discipline (第二次及以后的融合)

Reference for the `baton` skill — companion to the **"Merging / Consolidating
Batons"** section in SKILL.md (whose workflow steps 1–7 cover the first merge).

**Read this before merging a `.baton/` folder that has been merged before**
(any `-mer.md` exists in the directory). Learned from merges #2, #3, …: a second
merge is different from the first — there is a previous `-mer.md` to diff against,
the pile is bigger, and concurrent sessions are more likely to be writing into it
while you work.

Step numbers below continue the SKILL.md workflow numbering (8 onward).

---

## Step 8 — Pre-score every new file in one cheap pass, then read in batches

On a repeat merge only files newer than the last merged file matter — enumerate
them with mtime and print just title + TL;DR:

```bash
find . -maxdepth 1 -name "*.md" -newermt "<last merge timestamp>" -printf "%T@|%p\n" \
  | sort -n | while IFS='|' read t f; do echo "===== $f"; sed -n '1,4p' "$f"; echo; done
```

That yields the whole classification skeleton for a few hundred tokens; *then*
read full text in themed batches. A 27-file batch pre-screened this way and read
in 4 batches, instead of 27 full reads up front.

## Step 9 — The Iron Rule has a merge-side twin: a baton's recorded *state* rots

A baton is a snapshot; by the time you merge, later sessions have often already
landed exactly what it calls "uncommitted / waiting for review". **Never
transcribe commit status from batons** — re-derive it, per path the baton claims
is pending:

- `git log --oneline -- <path>` — did it land, and when?
- `git ls-files --error-unmatch <path>` — tracked vs. genuinely untracked.

Then write the delta into the conflict record ("baton says pending; reality:
landed in `<hash>`") so the next runner doesn't re-verify — or worse, re-commit.
In one merge, most "uncommitted, awaiting review" claims were already in history.

## Step 10 — Check for *conclusion-level* drift, not just file-level drift — read the authoritative doc the baton points at

Verifying commits proves the code is there; it says nothing about whether the
*decisions* moved on. A baton can end at "experiments not yet run" while the
direction doc already carries a verdict section. For every direction the batons
mark queued/running, locate the verdict by heading and read it:

```bash
grep -n "^#\{1,4\}.*<keyword>" <direction-doc>.md   # locate the section
sed -n '<start>,<end>p' <direction-doc>.md          # read the verdict paragraph
```

Write the verdict into the merged file. Skip this and the merged file is born
stale in its most load-bearing claim — the precise failure the baton pile was
supposed to prevent.

## Step 11 — Batch-verify every cited commit in one loop

Cheaper than one call per hash, and it catches two distinct failures:

```bash
for h in <hash1> <hash2> ...; do
  s=$(git log -1 --format="%h %s" "$h" 2>/dev/null)
  [ -z "$s" ] && echo "MISSING $h" || echo "$s"
done
```

`MISSING` = the baton cites a commit that isn't in history. And **read the
subject that comes back**: if it describes something unrelated to what the baton
claims that hash did, the baton *mis-cited* — re-find the real commit before
writing the claim. One loop over ~30 hashes is a single cheap call.

## Step 12 — Contradictions *inside one baton*: judge by evidence quality, not by date

A single file can assert "X always OOMs" and, further down, "【correction】
measured: X does not OOM; the real cause was Y" — while a *later* baton then
restates the stale half. Filename date cannot arbitrate that. Rule: **the version
backed by measurements (instrument readings, controlled comparison) wins**; a
later restatement of an old claim carries no new evidence. Record it as
"version A 作废 — no measurement; version B has measured data", and note in the
conflict block that recency alone was insufficient.

## Step 13 — Never copy plaintext credentials into the merged file

Source batons often carry passwords/tokens inline. Keep only the connection
coordinates (host, port, user, host-key fingerprint) plus a pointer to the
credential file, and say so explicitly in the file ("password not copied here —
see `<file>`"). Stating it prevents a downstream reader from thinking the merge
lost information.

## Step 14 — Give the merged file navigation — a status table and a coverage-gap section

Once a merge spans ~10 directions, add near the top:

- **📌 Status quick-reference** — `direction | status | top pending action`, so a
  new runner can triage without reading the whole file;
- **⚠️ Baton coverage gaps** — directions that are *active but have no baton at
  all*, reconstructed from direction docs + git alone. Without this list, the
  next session assumes those directions don't exist (one merge found three).

## Step 15 — Re-scan `.baton/` immediately before declaring the merge done — concurrent sessions drop batons while you work

A merge that started at 43 files ended at 47; the new file, dropped minutes
earlier, directly overturned a section written three minutes before. Protocol on
collision:

- **re-run `ls -la` + a file count as the last action before reporting**;
- insert an explicit **`🔴 progress update (<date>, source: <new file> — this
  file is the live baton for this direction)`** block at the **top** of the
  affected section;
- strike the overturned sentence as `~~...~~` + "superseded by the update
  above" — **never silently rewrite**;
- add a **【concurrent session】** entry to the conflict record, and point at the
  new file as the live authority for that direction.

---

## Cleanup variant (「清理 baton 文件夹」= merge outstanding window first, then archive)

When the user asks to **clean up** `.baton/` (not "merge"), that is a merge plus a
retirement step — never delete sources on merge-day instinct alone:

1. **Merge the un-merged window first** (files newer than the newest `-mer.md`),
   writing `<date>-<theme>-mer.md` as usual. Sources are only disposable once
   absorbed.
2. **Verify coverage arithmetic before moving anything**: round totals must add up
   (e.g. 13 + 27 + 18 = 58 sources ↔ every non-`-mer` file accounted for). Files
   edited *after* their merge snapshot need their post-merge deltas re-checked
   (head/tail) — capture anything new in the fresh round.
3. **Archive, don't delete**: `mkdir .baton/archive` and `mv` all absorbed sources
   there (a `case "$f" in *-mer.md) ;; *) mv ...` loop over `*.md`). The main
   folder is left with only the `-mer.md` files (the visible "clean"), nothing is
   unrecoverable, and the user can finish with `rm -rf .baton/archive` once
   satisfied — say so explicitly.
4. **Carry forward stale open items**: before the old sources leave the main
   folder, sweep the previous `-mer` files for open items with no activity in the
   merged window (e.g. a pending Step 0, an unconfirmed long-run) and give them a
   「仍无动静的旧开放项」section in the new `-mer` — silence means *no activity*,
   not *resolved*, and after archiving the sources those items live nowhere else.
5. **Re-scan for concurrent drops right before archiving** (Step 15 above) — a
   baton written minutes before the sweep must be merged, not archived raw.

---

## Common Mistakes (repeat-merge)

| Mistake | Fix |
|---------|-----|
| Baton's recorded commit status transcribed into the merged file | Baton state rots — later sessions land what the baton calls "pending". Re-derive per path: `git log --oneline -- <path>` + `git ls-files --error-unmatch <path>`; write "baton said pending; reality: landed in `<hash>`" into the conflict record. |
| Only git checked; direction docs' verdicts missed | A baton can stop at "not yet run" while the direction doc already carries a verdict. For each queued/running direction, locate the verdict section (`grep -n "^#\{1,4\}.*<kw>"`) and read it before writing the claim. |
| Every file read full-text just to classify | Pre-score in one pass: `find . -maxdepth 1 -name "*.md" -newermt "<last merge>" -printf "%T@\|%p\n"` piped to `sed -n '1,4p'` for title + TL;DR, then read in themed batches. |
| Cited commits asserted without verification | One batch loop over all hashes: `git log -1 --format="%h %s" <hash>`. Catches both `MISSING` hashes and *mis-citation* — a subject unrelated to the baton's claim means the baton cited the wrong commit. |
| Merge finalized without re-scanning `.baton/` | Concurrent sessions drop batons mid-merge (43 → 47 files in one merge). Re-run `ls -la` + count as the last step; on collision add a dated 🔴 progress-update block at the top of the section, strike the overturned line, and log a concurrent-session conflict entry — never a silent rewrite. |
| Intra-baton contradiction resolved by filename date | When one file contains both a claim and its later correction, recency can't arbitrate. The side backed by measurements wins; a later baton restating the old claim adds no evidence. Say so in the conflict record. |
| Plaintext credentials copied into the merged file | Keep connection coordinates (host/port/user/host-key) + a pointer to the credential file, and state "password not copied here" so it doesn't read as data loss. |
| ~10 directions merged with no navigation | Add a 📌 status quick-reference table (direction \| status \| top pending action) and a ⚠️ coverage-gap section listing active directions with *no* baton at all — otherwise the next session assumes they don't exist. |
