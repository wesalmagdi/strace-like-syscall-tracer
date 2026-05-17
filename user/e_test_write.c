// btest_open.c — Test 4: -e trace=open
//
// Run:   strace -e trace=open btest_open
// Expect trace output contains ONLY:
//   N: syscall open("README", 0) -> 3
//
// PASS if: open line appears, read/write/close/getpid do NOT appear
// FAIL if: any other syscall type appears in trace

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(void)
{
  char buf[8];

  int fd = open("README", O_RDONLY);   // SHOULD appear in trace
  if(fd < 0){ printf("FAIL: open failed\n"); exit(1); }

  int n = read(fd, buf, 8);            // should NOT appear in trace
  if(n <= 0){ printf("FAIL: read failed\n"); exit(1); }

  write(1, buf, n);                    // should NOT appear in trace
  close(fd);                           // should NOT appear in trace
  getpid();                            // should NOT appear in trace

  printf("\nPASS: e_test_write — trace should show ONLY write lines\n");
  exit(0);
}
