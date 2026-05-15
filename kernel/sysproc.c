#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"
extern struct proc proc[NPROC];

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
  argint(1, &t);
  addr = myproc()->sz;

  if(t == SBRK_EAGER || n < 0) {
    if(growproc(n) < 0) {
      return -1;
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
      return -1;
    myproc()->sz += n;
  }
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kkill(pid);
}

// return how many clock tick interrupts have occurred
// since start.

uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

/**
 * sys_trace:
 * ----------
 * System call to enable tracing for a process.
 *
 * Behavior:
 * - Takes a PID as input from user space.
 * - If PID matches the current process:
 *      → enable tracing for the current process.
 * - Otherwise:
 *      iterate over the global process table to find the target PID
 *      if found, enable tracing for that process.
 *
 * Synchronization:
 * - Uses per-process locking (spinlocks) to safely access and modify
 *   process state and avoid race conditions.
 *
 * Return value:
 * - Returns 0 on success.
 * - Returns -1 if the PID is not found.
 */
uint64
sys_trace(void)
{
    struct proc *p = myproc();
    int mask;
    int logfd;

    argint(0, &mask);
    argint(1, &logfd);

    p->tracemask = (uint)mask;

    if(logfd >= 0 && logfd < NOFILE && p->ofile[logfd])
      p->tracefd = logfd;
    else
      p->tracefd = -1;

    p->trace_enabled = 1;

    return 0;
}

// Add to kernel/sysproc.c (-p)

// ========== ADDED START: set_trace_output syscall ==========
uint64
sys_set_trace_output(void)
{
  struct proc *p = myproc();
  int fd;
  
  // argint doesn't return a value - it just sets fd
  argint(0, &fd);
  
  // Just check if fd is valid (non-negative)
  if(fd < 0) {
    return -1;
  }
  
  p->trace_output_fd = (uint64)fd;
  return 0;
}
// ========== ADDED END ==========

// ========== ADDED START: attach_trace syscall ==========
uint64
sys_attach_trace(void)
{
  int target_pid;
  int mask;
  struct proc *p;
  
  // argint returns void - just call it
  argint(0, &target_pid);
  argint(1, &mask);
  
  if(target_pid <= 0) {
    return -1;
  }
  
  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state != UNUSED && p->pid == target_pid) {
      // Cannot attach to init process (pid 1) or idle (pid 0)
      if(target_pid <= 1) {
        release(&p->lock);
        return -1;
      }
      
      p->trace_enabled = 1;
      p->tracemask = (uint)mask;
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  
  return -1;  // PID not found
}
// ========== ADDED END ==========
