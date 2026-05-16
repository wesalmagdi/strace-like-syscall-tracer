# Member A — Phase 2 Work Log

**Author:** Yasmin Ahmed Radwan
**Project:** xv6 strace-like System Call Tracer
**Repository:** https://github.com/wesalmagdi/strace-like-syscall-tracer
**Branch:** `yasmin-phase2`
**Date range:** 2026-05-15 → 2026-05-17

This document records every step of Phase 2 with the reasoning behind each decision.

---

## Phase 2 overview

After Phase 1 (Bug 1, 2, 7 fixes + bonus + tests, merged via PR #1), I delivered one **fork-filter inheritance bug fix** plus **three new strace flags** on top of the existing project, all on branch `yasmin-phase2`:

| Step | What | Why | Files touched |
|---|---|---|---|
| 1 | Fork-filter `tracemask` inheritance | `-e` filter was silently bypassed by children | `kernel/proc.c` |
| 2 | `-Z` / `--status=failed` | Filter trace output to only failed syscalls | `kernel/syscall.h`, `kernel/syscall.c`, `user/strace.c` |
| 3 | `-c` / `--summary` + `--summary-only` | Per-process syscall counters + exit summary table | `kernel/proc.h`, `kernel/proc.c`, `kernel/syscall.c`, `kernel/defs.h`, `kernel/sysproc.c`, `user/strace.c` |
| 4 | `-y` / `--decode-fds` | Annotate fd args with paths (e.g. `read(3<README>, ...)`) | `kernel/proc.h`, `kernel/proc.c`, `kernel/syscall.c`, `user/strace.c` |
| Bonus | `.gitignore` cleanup | Stop tracking build artifacts | `.gitignore`, plus untrack ops |

All four new flags ride on **unused high bits of the existing `tracemask` int** (bits 27–30) so Member B's `trace(int)` signature stays unchanged.

```
mask layout:
┌────────┬───────────────────────────────────────┐
│ 31..27 │ mode flags (Z, c, summary-only, y)    │
│ 26..23 │ reserved                              │
│ 22..1  │ syscall filter (Member B's design)    │
└────────┴───────────────────────────────────────┘
```

Defined in `kernel/syscall.h`:
```c
#define TRACE_FLAG_FAILED_ONLY    (1u << 27)   // -Z / --status=failed
#define TRACE_FLAG_SUMMARY        (1u << 28)   // -c / --summary
#define TRACE_FLAG_SUMMARY_ONLY   (1u << 29)   // --summary-only
#define TRACE_FLAG_DECODE_FDS     (1u << 30)   // -y / --decode-fds
#define TRACE_SYSCALL_BITS        0x007FFFFFu  // bits 0..22 = Member B's syscall filter
```

---

## Step 1 — Fork-filter inheritance bug fix

### What was wrong
`kfork()` in `kernel/proc.c` was missing `np->tracemask = p->tracemask;`. After Member B's `-e` filter shipped and my Bug 1 fix made children visible, this gap became reachable:
- Parent: filter active, prints only `getpid`.
- Child (after fork): `tracemask == 0` in the freshly-allocated slot. Member B's design treats `tracemask == 0` as "no filter / trace all".
- Result: parent looked correct, but every child silently leaked unfiltered output.

### Fix
One line in `kfork()` after the existing `np->trace_enabled = p->trace_enabled;`:
```c
np->tracemask = p->tracemask;
```

### Why this approach
- Matches the one-line pattern of the existing inheritance lines.
- No new syscall, no signature change, no user-space change.
- Compatible with every other feature on the branch.

### Verification
- `strace -e trace=getpid forktracetest` BEFORE: parent's filtered output + leaked child syscalls.
- AFTER: parent's `getpid` + each child's `getpid`, ZERO other syscalls.

### Commit
`61f3444 Fix: tracemask not inherited in kfork — filter now survives fork`

---

## Step 2 — `-Z` / `--status=failed`

### Motivation
When a syscall fails (`-1`), you usually want to find it fast. Today's per-line output puts each failure in a sea of successes. Real strace's `-Z` flag filters to show only the failing lines. Pairs perfectly with my Phase 1 `(failed)` decoration — the decoration makes a single failure visually distinct; `-Z` makes the failure set isolatable.

### Implementation
- `kernel/syscall.h`: added `#define TRACE_FLAG_FAILED_ONLY` and the `TRACE_SYSCALL_BITS` mask.
- `kernel/syscall.c`: split `tracemask` into `sc_bits = mask & TRACE_SYSCALL_BITS` for the syscall filter; added a `passes_failed_gate` check that suppresses the print unless `ret == -1` when the flag is set.
- `user/strace.c`: added `-Z` / `--status=failed` argument parsing, OR-ing `TRACE_FLAG_FAILED_ONLY` into the existing mask (so it composes with `-e`).

### Why high-bit flag encoding (not new syscalls)
- Member B's existing `int trace(int)` stays unchanged.
- All four new flags share a single integer.
- Self-documenting via `#define`s in `syscall.h`.
- Trivial to test combinations (`-Z -c`, `-y -Z`, etc.) — just OR more bits.

### Tests (in xv6)
| Test | Expected |
|---|---|
| `strace -Z terrtest` | Exactly 3 lines, all `-> -1 (failed)` |
| `strace -Z cat README` | Zero trace lines; cat's content prints normally |
| `strace -Z cat doesnotexist` | One trace line: `open(...) -> -1 (failed)` |
| `strace -e trace=open -Z cat doesnotexist` | Same as above (open in filter, fails) |
| `strace -e trace=read -Z cat doesnotexist` | Zero trace lines (the failure is open, not read) |
| `strace -Z forktracetest` | Zero (no failures); proves flag survives fork |

All passed.

### Commit
`32e3d60 Feature: -Z / --status=failed — only print failing syscalls; high-bit flag encoding`

---

## Step 3 — `-c` / `--summary` (and `--summary-only`)

### Motivation
Two questions strace users always ask:
- "What did this program actually do at the syscall level?" → answered by `-c` (full summary table at exit).
- "I don't care about per-line output; just give me the summary." → answered by `--summary-only`.

Direct port of Linux strace's `-c`. The `errors` column ties back to `(failed)` decorations and `-Z`.

### Implementation
- `kernel/proc.h`: added `uint trace_count[32]` and `uint trace_errors[32]` to `struct proc`.
- `kernel/proc.c` `allocproc()`: zero both arrays.
- `kernel/proc.c` `kfork()`: explicitly reset child's counters to 0 (counters are per-process, not inherited).
- `kernel/syscall.c`: increment `trace_count[num]` and (if `ret == -1`) `trace_errors[num]` after every syscall.
- `kernel/syscall.c`: added `print_trace_summary(struct proc *)` — formatted tab-aligned table.
- `kernel/defs.h`: forward declaration for `print_trace_summary`.
- `kernel/sysproc.c` `sys_exit()`: call `print_trace_summary(p)` before `kexit(n)` when `TRACE_FLAG_SUMMARY` is set.
- `kernel/syscall.c` print gate: also gate on `TRACE_FLAG_SUMMARY_ONLY` to suppress per-line output.
- `user/strace.c`: parse `-c`, `--summary`, `--summary-only`.

### Design decisions
1. **Counters always increment when tracing is on** — they reflect what the program DID, not what was printed. So `-c` shows the truth even when `-Z` or `-e` filters the per-line output. Important: the summary's `errors` column matches the failed-syscall set exactly.
2. **xv6's `printf` doesn't support width specifiers** (`%4d`, `%9d`) — they print literally and cause panic via va_arg misalignment. The summary uses only plain `%d`/`%s`/`\t` (tabs) for alignment. Discovered the hard way (panic: acquire).
3. **Per-process counters in `struct proc`**, not in a global pool. Each forked child gets its own counters reset in `kfork()`. When a child exits, IT prints its own summary. This produces multiple summary tables for fork-heavy programs — by design.
4. **`sys_exit` hook is BEFORE `kexit`** so the summary prints while the process is still around. The summary line doesn't include `exit` itself in the count because we hook before incrementing for SYS_exit. Acceptable side-effect.

### Tests
| Test | Expected | Result |
|---|---|---|
| `strace -c cat README` | Per-line trace + summary at end, all 0 errors | ✅ |
| `strace -c terrtest` | Summary shows `open`, `kill`, `unlink` each with `errors=1` | ✅ |
| `strace --summary-only cat README` | Just cat's content + summary, no per-line | ✅ |
| `strace -Z -c terrtest` | Per-line shows only 3 failures; summary shows ALL 66 syscalls | ✅ |
| `strace -e trace=open,read -c wc README` | Per-line filtered to open/read; summary shows all syscalls | ✅ |
| `strace -c forktracetest` | Multiple tables (parent + each child); each with its own counts | ✅ |

### Commit
`Feature: -c / --summary — per-process counters + exit summary table` (commit SHA in your log)

---

## Step 4 — `-y` / `--decode-fds`

### Motivation
File descriptors in trace output are bare integers. `read(3, ..., 512)` tells you nothing about what fd 3 is. With `-y`, every fd argument is annotated with its path in-place: `read(3<README>, ..., 512)`. This is the single biggest readability win in real strace.

### Implementation
- `kernel/proc.h`: added `char fd_path[NOFILE][128]` to `struct proc` (16 × 128 = 2 KB per process).
- `kernel/proc.c` `allocproc()`: clear all `fd_path` entries.
- `kernel/proc.c` `kfork()`: deep-copy parent's `fd_path` table into child.
- `kernel/syscall.c`: added `arg_is_fd(num, i)` helper (which syscalls have fd args, at which positions).
- `kernel/syscall.c` `syscall()`: hook after each syscall completes — record on successful `open`, clear on successful `close`, copy on successful `dup`.
- `kernel/syscall.c` `trace_syscall()`: when printing an argument that's an fd AND the flag is set AND the table has an entry, print `N<path>` instead of bare `N`.
- `user/strace.c`: parse `-y` / `--decode-fds`.

### Design decisions
1. **Storage as a flat `char[NOFILE][128]`**, not dynamic. xv6 has no kernel `malloc`. 2 KB per process is acceptable.
2. **MAXPATH issue.** I initially used `MAXPATH` (defined in `fs.h`), but adding `#include "fs.h"` to `proc.h` caused circular include errors (fs.h has no include guards). Fix: hardcoded `128` in `proc.h` (matches MAXPATH numerically). `syscall.c` already includes `fs.h` from the existing Member B/C code, so it still uses `MAXPATH` there.
3. **Hook order matters.** I initially placed the table-update block BEFORE the per-line print. This caused `close(fd)` to lose its annotation — the print would look up `fd_path[fd]` AFTER the clear had emptied it. Fix: moved the hook block to AFTER the print. Now `close(3<README>) -> 0` correctly shows the path on the same line it's freed.
4. **`pipe()` not decoded** — its return is via a user-space `int[2]` pointer; would need a `copyin` to read. Documented as a known limitation.
5. **fds 0/1/2 inherited from the shell** show as bare numbers (e.g. `write(1, ...)`). We didn't see the open, so we don't have a path. Could default to `<stdin>` / `<stdout>` / `<stderr>` in a future iteration.
6. **`fork()` inheritance.** The deep copy in `kfork()` means a child sees the same path strings as the parent for any fds the parent had open. Combined with my Phase 1 / Phase 2 inheritance work for `trace_enabled` and `tracemask`, this completes Feature C properly.

### Tests
| Test | Expected | Result |
|---|---|---|
| `strace -y cat README` | `open("README", O_RDONLY) -> 3`, `read(3<README>, ...)`, `write(1, ...)` (no annotation, no path recorded), `close(3<README>)` | ✅ |
| `strace -y stracetest2` | `dup(3<README>) -> 4`, then `close(4<README>)` and `close(3<README>)` | ✅ |
| `strace -y cat doesnotexist` | `open(...) -> -1 (failed)`, no fd added to table | ✅ |
| `strace -y forktracetest` | Children inherit parent's table | ✅ |
| `strace -y -Z cat doesnotexist` | Only the failed open line (no fd to annotate) | ✅ |
| `strace -y -c cat README` | Annotated per-line + summary | ✅ |
| `strace -y -c -e trace=open,read,close cat README` | All 4 flags combined cleanly | ✅ |

### Commit
`Feature: -y / --decode-fds — annotate fd args with paths, fork-aware table` (commit SHA in your log)

---

## Bonus — `.gitignore` cleanup

Build artifacts (`.o`, `.d`, `.asm`, `.sym`, `kernel/kernel`, `user/_*`, `fs.img`, etc.) were being tracked, cluttering `git status` and `git diff` with hundreds of binary modifications. Added a `.gitignore` and untracked all build outputs:

```gitignore
*.o
*.d
*.asm
*.sym
kernel/kernel
kernel/kernel.asm
kernel/kernel.sym
mkfs/mkfs
user/_*
fs.img
fs.img.bk
*.img.bk
*.swp
.gdbinit
```

From this commit onwards, only source files appear in `git status`.

---

## Cross-cutting issues that came up

### xv6's `printf` doesn't support width specifiers
`%4d`, `%9d`, etc. print literally. Worse, the va_arg machinery goes out of sync, so subsequent `%s` reads an int as if it were a `char *`, triggering page fault, which acquires the console lock, which panics because the original `printf` already held it. **Lesson:** in xv6 kernel `printf`, use only `%d`, `%s`, `%c`, `%x`, `%p`, `%%` — no width or precision modifiers. Tabs for alignment.

### Circular include from `fs.h`
xv6's headers don't have include guards. Adding `#include "fs.h"` to `proc.h` broke multiple .c files that already included both. **Lesson:** avoid adding includes to widely-used headers. Hardcode constants if needed.

### Hook ordering for `-y`
Placing the fd-table update before the print line breaks `close()` annotation. The print needs to see the path that the hook is about to clear. **Lesson:** when state changes during a syscall, decide carefully whether the print observes the pre-state or post-state.

### Multiple "modified" build artifacts when committing
Even with the `.gitignore`, `git status` showed every `.o` as modified because they had been committed before in earlier sessions. **Lesson:** `git rm --cached` removes from index without deleting the file on disk — the right tool when you want to UNTRACK files.

---

## Final commit list on `yasmin-phase2` branch

```
<sha>  Feature: -y / --decode-fds — annotate fd args with paths, fork-aware table
<sha>  Feature: -c / --summary — per-process counters + exit summary table
<sha>  chore: add .gitignore for build artifacts; untrack generated files
32e3d60  Feature: -Z / --status=failed — only print failing syscalls; high-bit flag encoding
61f3444  Fix: tracemask not inherited in kfork — filter now survives fork
0d18bb2  (origin/main) Merge pull request #2 from wesalmagdi/Dev/wesal
```

(Replace `<sha>` with the actual hashes from your `git log --oneline -6`.)

---

## What's still pending after Phase 2

| Item | Owner | Status |
|---|---|---|
| Bug 3 (console mixing) | Member C | Documented as "use `-o filename`" |
| Bug 8 (exec argv address) | Member C | Documented as intentional |
| Bug 9 (exec return + missing exit) | Member C | Fixed |
| Bug 10 (`strace ls` flood) | Member C | Documented |
| Feature `-o filename` | Member C | Done (in `main`) |
| Feature `-p pid` / `--attach` | Member B/other | Done (in `main`) |
| `pipe()` fd annotation | future work | TODO — needs `copyin` for the int[2] return |
| Default stdin/stdout/stderr fd path | future work | TODO — minor polish |

---

*End of work log.*
