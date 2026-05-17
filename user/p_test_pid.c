// p_test_pid.c — Attach target for -p testing
//
// Run this in background, then attach strace to its PID:
//
//   $ p_test_pid &
//   PID: 4          ← note this number
//   $ strace -p 4
//   strace: attached to pid 4
//   4: syscall getpid() -> 4     ← syscalls appear
//   4: syscall write(1, ...) -> ...
//   ...
//
// PASS if: strace -p <PID> prints "strace: attached to pid <PID>"
//          and syscall lines appear from the target process

#include "kernel/types.h"
#include "user/user.h"

int main(void)
{
  int pid = getpid();
  printf("PID: %d\n", pid);
  printf("Run: strace -p %d\n", pid);
  printf("Looping — attach strace now\n");

  // loop making syscalls so strace has something to show
  for(int i = 0; i < 20; i++){
    getpid();
    pause(10);
  }

  printf("PASS: p_test_pid — loop done\n");
  exit(0);
}
