
## 1. Feature: Timestamped Syscall Tracing

Goal:
Add timestamps to syscall tracing output to improve debugging and execution ordering visibility.

## 2. Design Overview
The system uses a global kernel counter ticks
ticks increments on every timer interrupt
We convert ticks into seconds using a constant tick rate HZ
#define HZ 100   // number of ticks per second
## 3. Implementation Changes
🔹 A. Timestamp formatting added in syscall trace

Before:

syscall read(...)

After:

[12.34s] syscall read(...)
🔹 B. Conversion logic added
int seconds = ticks / HZ;
int fraction = (ticks % HZ) * 100 / HZ;
🔹 C. Updated trace output formatting
append_char(line, &pos, sizeof(line), '[');
append_dec(line, &pos, sizeof(line), seconds);
append_char(line, &pos, sizeof(line), '.');
append_dec(line, &pos, sizeof(line), fraction);
append_str(line, &pos, sizeof(line), "s] ");
## 4. Files Modified

List this clearly:

kernel/syscall.c → added timestamp formatting
kernel/param.h → added #define HZ 100
## 5. Behavior Change

Syscall logs now include relative system uptime timestamp, measured in seconds since boot.

## 6. Limitations
Time is based on ticks, not real-world clock
Resolution depends on HZ (e.g., 100 → 10ms accuracy)
Not persistent across reboot

##7.Testing

A user-level test program trace_test was added to validate the syscall tracing and timestamp functionality. The program generates a controlled sequence of system calls to verify that tracing is correctly enabled, syscalls are captured in order, and timestamps are properly attached.

The test performs file operations including open, read, and close on an existing file (README). It also executes additional system calls such as getpid and sleep to generate a mix of fast and delayed syscalls, allowing verification of timestamp progression over time.

The expected behavior is that each syscall is printed in the trace output with the process ID, syscall name, arguments, return value, and a timestamp in seconds derived from kernel ticks.

The program was executed using the strace wrapper to enable tracing:

strace -t trace_test

The output confirms correct functionality when syscall traces appear in order and timestamps increase as the program executes. Repeated fast syscalls may share the same timestamp if they occur within the same kernel tick interval, which is expected behavior.

The test also verifies that sleep-based syscalls cause observable time advancement in the trace output, confirming correct tick-to-time conversion.
