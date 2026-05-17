// System call numbers
#define SYS_fork    1
#define SYS_exit    2
#define SYS_wait    3
#define SYS_pipe    4
#define SYS_read    5
#define SYS_kill    6
#define SYS_exec    7
#define SYS_fstat   8
#define SYS_chdir   9
#define SYS_dup    10
#define SYS_getpid 11
#define SYS_sbrk   12
#define SYS_pause  13
#define SYS_uptime 14
#define SYS_open   15
#define SYS_write  16
#define SYS_mknod  17
#define SYS_unlink 18
#define SYS_link   19
#define SYS_mkdir  20
#define SYS_close  21
#define SYS_trace  22
#define SYS_attach_trace 23
#define SYS_set_trace_output 24
#define SYS_detach_trace 25
#define TRACE_FLAG_TIMESTAMP (1u << 26)
// Phase 2 — high-bit flags on the trace mask.
// Syscall bits live in bits 0..22.
//
// All four flags fit in the same int that Member B already passes via trace().

#define TRACE_SYSCALL_BITS        0x007FFFFFu  // bits 0..22 — Member B's syscall filter

#define TRACE_FLAG_FAILED_ONLY    (1u << 27)   // -Z / --status=failed
#define TRACE_FLAG_SUMMARY        (1u << 28)   // -c / --summary
#define TRACE_FLAG_SUMMARY_ONLY   (1u << 29)   // --summary-only; implies SUMMARY
#define TRACE_FLAG_DECODE_FDS     (1u << 30)   // -y / --decode-fds
#define SYS_set_interruptible 26
