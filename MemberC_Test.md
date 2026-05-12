# Member C Test Cases — Minimal Documentation

## T1 — Existing Smoke Tests

### Purpose
Make sure the original tracer behavior still works after Member C changes.

### Tests Run
- `strace stracetest1`
- `strace stracetest2`
- `strace stracetest3`

### Expected Result
All three programs run successfully and show the expected syscall traces.

### Result
Passed. The original smoke tests still work.

---

## T6 — Tracing Continues Across `exec`

### Purpose
Make sure tracing continues when a program uses `exec` to replace itself with another program.

### Test Run
- `strace execchaintest`

### Expected Result
Program A execs Program B, then Program B execs Program C. All trace lines should stay under the same PID, because `exec` changes the program but not the process.

### Result
Passed. All exec-chain trace lines appeared under the same PID, and the exec path strings appeared correctly.

---

## T8 — Tracer Survives Heavy Load

### Purpose
Make sure the tracer can handle many syscalls without crashing or missing output.

### Test Run
- `strace -o loadlog.txt loadtest`

### Expected Result
The program performs many `getpid()` calls and many `sbrk(0)` calls. The tracer should complete without panic and write the trace lines to the log file.

### Result
Passed. The tracer handled the heavy syscall load successfully.

---

## T9 — Untraced Background Program Does Not Appear

### Purpose
Make sure tracing is process-specific and not global.

### Test Run
- Started `bgtest` in the background.
- Ran `strace -o fglog.txt stracetest1`.
- Checked `fglog.txt`.

### Expected Result
The trace log should contain only the foreground traced process and its child. The background `bgtest` PID should not appear.

### Result
Passed. The background program did not appear in the foreground trace log.

---

## T10 — `cat` Still Works After 1-Byte Write Filter

### Purpose
Make sure the 1-byte write filter does not break normal file output.

### Test Run
- `strace cat README`

### Expected Result
The README content should display correctly. The trace should show normal multi-byte read/write activity without flooding with 1-byte writes.

### Result
Passed. `cat README` worked correctly and did not flood with 1-byte write traces.

---

## T11 — `strace ls` Output Check

### Purpose
Make sure `strace ls` remains readable and does not flood because of repeated 1-byte writes.

### Test Run
- `strace ls`

### Expected Result
The trace should mainly show the normal directory traversal pattern such as open, fstat, read, close, and exit.

### Result
Passed. The output was long because the directory had many files, but it was not caused by repeated 1-byte write flooding.

---

## `otrace_test` — `-o` Log File Output

### Purpose
Test the Member C `-o` log-file feature with and without syscall filtering.

### Tests Run
- `strace -o olog.txt otrace_test`
- `strace -e trace=write -o owlog.txt otrace_test`
- `strace -e trace=open,read,close,exit -o oflag.txt otrace_test`

### Expected Result
Program output should stay on the console. Trace output should go to the selected log file. Filtering should still work with `-o`.

### Result
Passed. `-o` worked correctly, filtering worked with `-o`, and `exit` appeared correctly when included in the filter.

---