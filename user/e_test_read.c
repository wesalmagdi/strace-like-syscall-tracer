// btest_read_write.c — Test 5: -e trace=read,write (multi filter)
//
// Run:   strace -e trace=read,write btest_read_write
// Expect trace output contains ONLY:
//   N: syscall read(3, ..., 8) -> 8
//   N: syscall write(1, ..., 8) -> 8
//
// PASS if: read and write lines appear, open/close/getpid do NOT appear
// FAIL if: open, close, or getpid appear in trace

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

  write(1, buf, n);                    // SHOULD appear in trace
  close(fd);                           // should NOT appear in trace
  getpid();                            // should NOT appear in trace

  printf("\nPASS: e_test_read — trace should show ONLY read lines\n");
  exit(0);
}
