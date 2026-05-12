# Member C — Bug Documentation

## Bug 3 — Trace Output and Program Output Mix

### Problem
Program output and trace output can appear on the same console line.

### What was observed
When the traced program printed characters without a newline, the next trace line started immediately after the program output.

### Investigation
The issue was tested multiple times using a small program that writes characters and then calls syscalls.

No kernel panic, freeze, recursive tracing, or deadlock was observed.

### Decision
No code change was made for this bug.

### Final Conclusion
Bug 3 is mainly a readability issue, not a correctness or deadlock issue. The proper way to separate program output from trace output is to use the `-o` feature, which writes trace output to a file (which I implemented as my feature).


---

## Bug 8 — exec argv Shows as Raw Address

### Problem
The second argument of `exec` appears as a number.

### Reason
The first argument of `exec` is the path string, which can be decoded. The second argument is a pointer to the argv array in user memory, so it appears as a raw address.

### Decision
No code change was made.

### Final Conclusion
This is expected behavior. Decoding the full argv array is out of scope for this project.


---

## Bug 9 — Wrong exec Display and Missing exit

### Problem
Successful `exec` showed a confusing return value, and `exit` did not appear in trace output.

### Reason
Successful `exec` does not return normally to the old program. Also, `exit` terminates the process and does not return through the normal syscall tracing path.

### What was fixed
Successful `exec` now displays as a successful operation. The missing `exit` trace was added through the process exit path.

### Final Conclusion
Bug 9 was fixed. Successful `exec` is now clearer, and `exit(status)` appears correctly in trace output.


---

## Bug 10 — strace ls Produces Long Output

### Problem
Running `strace ls` produced a long trace output.

### Initial Suspicion
The suspicion was that `ls` was causing many 1-byte write traces.

### Investigation
The trace output did not show repeated 1-byte write flooding(was handled by member B). Instead, it showed normal directory operations such as opening files, reading directory entries, checking file status, and closing files.

### Decision
No code change was made.

### Final Conclusion
The long output is legitimate syscall activity from `ls`, not a tracer bug. The existing 1-byte write filter is working.