#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"
#include "defs.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"


static void
append_char(char *buf, int *pos, int max, char c)
{
  if(*pos < max - 1){
    buf[*pos] = c;
    (*pos)++;
    buf[*pos] = 0;
  }
}

static void
append_str(char *buf, int *pos, int max, char *s)
{
  while(s && *s)
    append_char(buf, pos, max, *s++);
}

static void
append_dec(char *buf, int *pos, int max, long x)
{
  char tmp[32];
  int i = 0;
  unsigned long y;

  if(x < 0){
    append_char(buf, pos, max, '-');
    y = (unsigned long)(-x);
  } else {
    y = (unsigned long)x;
  }

  do {
    tmp[i++] = '0' + (y % 10);
    y /= 10;
  } while(y != 0);

  while(i > 0)
    append_char(buf, pos, max, tmp[--i]);
}

static void
append_open_flags_buf(char *buf, int *pos, int max, int flags)
{
  switch(flags & 0x003){
  case 0:
    append_str(buf, pos, max, "O_RDONLY");
    break;
  case 1:
    append_str(buf, pos, max, "O_WRONLY");
    break;
  case 2:
    append_str(buf, pos, max, "O_RDWR");
    break;
  default:
    append_str(buf, pos, max, "O_???");
    break;
  }

  if(flags & 0x200)
    append_str(buf, pos, max, "|O_CREATE");

  if(flags & 0x400)
    append_str(buf, pos, max, "|O_TRUNC");
}


static void
trace_emit(struct proc *p, char *line)
{
  int n = strlen(line);

  if(p->tracefd >= 0 &&
     p->tracefd < NOFILE &&
     p->ofile[p->tracefd] &&
     p->ofile[p->tracefd]->writable &&
     p->ofile[p->tracefd]->type == FD_INODE) {

    struct file *f = p->ofile[p->tracefd];

    begin_op();
    ilock(f->ip);
    int r = writei(f->ip, 0, (uint64)line, f->off, n);
    if(r > 0)
      f->off += r;
    iunlock(f->ip);
    end_op();

    if(r == n)
      return;
  }

  printf("%s", line);

}

void trace_syscall(struct proc *p, int num, uint64 *args, uint64 ret);
// ---------- Bonus: symbolic decoding for open() flags ----------

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
  struct proc *p = myproc();
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    return -1;
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    return -1;
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
  struct proc *p = myproc();
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    return -1;
  return strlen(buf);
}

static uint64
argraw(int n)
{
  struct proc *p = myproc();
  switch (n) {
  case 0:
    return p->trapframe->a0;
  case 1:
    return p->trapframe->a1;
  case 2:
    return p->trapframe->a2;
  case 3:
    return p->trapframe->a3;
  case 4:
    return p->trapframe->a4;
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
  *ip = argraw(n);
}

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
  *ip = argraw(n);
}

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
}

// Prototypes for the functions that handle system calls.
extern uint64 sys_fork(void);
extern uint64 sys_exit(void);
extern uint64 sys_wait(void);
extern uint64 sys_pipe(void);
extern uint64 sys_read(void);
extern uint64 sys_kill(void);
extern uint64 sys_exec(void);
extern uint64 sys_fstat(void);
extern uint64 sys_chdir(void);
extern uint64 sys_dup(void);
extern uint64 sys_getpid(void);
extern uint64 sys_sbrk(void);
extern uint64 sys_pause(void);
extern uint64 sys_uptime(void);
extern uint64 sys_open(void);
extern uint64 sys_write(void);
extern uint64 sys_mknod(void);
extern uint64 sys_unlink(void);
extern uint64 sys_link(void);
extern uint64 sys_mkdir(void);
extern uint64 sys_close(void);
// add to dispatch table
extern uint64 sys_trace(void);
// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64 (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_pause]   sys_pause,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
[SYS_trace]   sys_trace,
};

// syscall names indexed by syscall number (see syscall.h)
static char *syscall_names[] = {
[SYS_fork]    "fork",
[SYS_exit]    "exit",
[SYS_wait]    "wait",
[SYS_pipe]    "pipe",
[SYS_read]    "read",
[SYS_kill]    "kill",
[SYS_exec]    "exec",
[SYS_fstat]   "fstat",
[SYS_chdir]   "chdir",
[SYS_dup]     "dup",
[SYS_getpid]  "getpid",
[SYS_sbrk]    "sbrk",
[SYS_pause]   "pause",
[SYS_uptime]  "uptime",
[SYS_open]    "open",
[SYS_write]   "write",
[SYS_mknod]   "mknod",
[SYS_unlink]  "unlink",
[SYS_link]    "link",
[SYS_mkdir]   "mkdir",
[SYS_close]   "close",
[SYS_trace]   "trace",
};

// number of arguments each syscall reads from a0..a5
static int syscall_nargs[] = {
[SYS_fork]    0,
[SYS_exit]    1,
[SYS_wait]    1,
[SYS_pipe]    1,
[SYS_read]    3,
[SYS_kill]    1,
[SYS_exec]    2,
[SYS_fstat]   2,
[SYS_chdir]   1,
[SYS_dup]     1,
[SYS_getpid]  0,
[SYS_sbrk]    1,
[SYS_pause]   1,
[SYS_uptime]  0,
[SYS_open]    2,
[SYS_write]   3,
[SYS_mknod]   3,
[SYS_unlink]  1,
[SYS_link]    2,
[SYS_mkdir]   1,
[SYS_close]   1,
[SYS_trace]   0,
};

// returns 1 if argument i of syscall num is a user-space path string.
// SYS_exec is excluded: exec replaces user memory before trace_syscall runs,
// so we pre-fetch its path in syscall() instead.
static int
arg_is_path(int num, int i)
{
  if(i == 0)
    return num == SYS_open || num == SYS_mkdir ||
           num == SYS_chdir || num == SYS_unlink || num == SYS_link ||
           num == SYS_mknod;
  if(i == 1)
    return num == SYS_link;
  return 0;
}


void
trace_syscall(struct proc *p, int num, uint64 *args, uint64 ret)
{
  if(num <= 0 || num >= NELEM(syscall_names) || syscall_names[num] == 0)
    return;

  char line[256];
  char pathbuf[128];
  int pos = 0;
  line[0] = 0;

  append_dec(line, &pos, sizeof(line), p->pid);
  append_str(line, &pos, sizeof(line), ": syscall ");
  append_str(line, &pos, sizeof(line), syscall_names[num]);
  append_char(line, &pos, sizeof(line), '(');

  int n = syscall_nargs[num];

  for(int i = 0; i < n; i++){
    if(i > 0)
      append_str(line, &pos, sizeof(line), ", ");

    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
      append_char(line, &pos, sizeof(line), '"');
      append_str(line, &pos, sizeof(line), pathbuf);
      append_char(line, &pos, sizeof(line), '"');
    } else if(num == SYS_open && i == 1) {
      append_open_flags_buf(line, &pos, sizeof(line), (int)args[i]);
    } else {
      append_dec(line, &pos, sizeof(line), (long)args[i]);
    }
  }

  if((long)ret == -1){
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
  } else {
    append_str(line, &pos, sizeof(line), ") -> ");
    append_dec(line, &pos, sizeof(line), (long)ret);
    append_char(line, &pos, sizeof(line), '\n');
  }

  trace_emit(p, line);
}


static void
trace_exec(struct proc *p, char *exec_path, uint64 argv_addr, uint64 ret)
{
  char line[256];
  int pos = 0;
  line[0] = 0;

  append_dec(line, &pos, sizeof(line), p->pid);
  append_str(line, &pos, sizeof(line), ": syscall exec(\"");
  append_str(line, &pos, sizeof(line), exec_path);
  append_str(line, &pos, sizeof(line), "\", ");
  append_dec(line, &pos, sizeof(line), (long)argv_addr);

  if((long)ret == -1)
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
  else
    append_str(line, &pos, sizeof(line), ") -> 0\n");

  trace_emit(p, line);
}


void
trace_exit(struct proc *p, int status)
{
  if(p->trace_enabled &&
     (p->tracemask == 0 || (p->tracemask & (1 << SYS_exit)))) {
    char line[128];
    int pos = 0;
    line[0] = 0;

    append_dec(line, &pos, sizeof(line), p->pid);
    append_str(line, &pos, sizeof(line), ": syscall exit(");
    append_dec(line, &pos, sizeof(line), status);
    append_str(line, &pos, sizeof(line), ")\n");

    trace_emit(p, line);
  }
}


void
syscall(void)
{
  struct proc *p = myproc();
  int num = p->trapframe->a7;
  

  if(num <= 0 || num >= NELEM(syscalls) || syscalls[num] == 0){
    printf("%d %s: unknown sys call %d\n",
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    return;
  }

  uint64 saved_args[3];
  saved_args[0] = p->trapframe->a0;
  saved_args[1] = p->trapframe->a1;
  saved_args[2] = p->trapframe->a2;

  // exec replaces user memory, so the path string at saved_args[0] is
  // unreadable after the call returns. Snapshot it now.
  char exec_path[128];
  int have_exec_path = 0;
  if(num == SYS_exec)
    have_exec_path = (fetchstr(saved_args[0], exec_path, sizeof(exec_path)) >= 0);
// Bug 7: do_trace is snapshotted before syscalls[num]() runs.
// For SYS_trace, p->trace_enabled is still 0 here, so the trace()
// call itself never appears in its own output. This is intentional.
int do_trace =
    p->trace_enabled &&
    (p->tracemask == 0 || (p->tracemask & (1 << num)));

uint64 ret = syscalls[num]();
p->trapframe->a0 = ret;

int noisy =
    (num == SYS_write &&
     (saved_args[0] == 1 || saved_args[0] == 2) &&
     saved_args[2] == 1);

if (do_trace && !noisy) {
    if (num == SYS_exec && have_exec_path) {
      trace_exec(p, exec_path, saved_args[1], ret);
    } else {
        trace_syscall(p, num, saved_args, ret);
    }
}

}
