// btest_read.c — Test 2: -e trace=read
//
// Run:   strace -e trace=read btest_read
// Expect trace output contains ONLY:
//   N: syscall read(3, ..., 8) -> 8
//
// PASS if: read line appears, open/write/close/getpid do NOT appear
// FAIL if: any other syscall type appears in trace

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(void)
{
  char buf[8];

  int fd = open("README", O_RDONLY);   // should NOT appear in trace
  if(fd < 0){ printf("FAIL: open failed\n"); exit(1); }

  int n = read(fd, buf, 8);            // SHOULD appear in trace
  if(n <= 0){ printf("FAIL: read failed\n"); exit(1); }

  write(1, buf, n);                    // should NOT appear in trace
  close(fd);                           // should NOT appear in trace
  getpid();                            // should NOT appear in trace

  printf("\nPASS: e_testrw — trace should show ONLY read and write lines\n");
  exit(0);
}

