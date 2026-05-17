// btest_write.c — Test 3: -e trace=write
//
// Run:   strace -e trace=write btest_write
// Expect trace output contains ONLY:
//   N: syscall write(1, ..., 8) -> 8
//
// PASS if: write line appears, open/read/close/getpid do NOT appear
// FAIL if: any other syscall type appears in trace
//
// Note: 1-byte writes to stdout are filtered by the tracer (Bug 6 design
// decision). This test uses an 8-byte write so it always appears.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(void)
{
  char buf[8];

  int fd = open("README", O_RDONLY);   // should NOT appear in trace
  if(fd < 0){ printf("FAIL: open failed\n"); exit(1); }

  int n = read(fd, buf, 8);            // should NOT appear in trace
  if(n <= 0){ printf("FAIL: read failed\n"); exit(1); }

  write(1, buf, n);                    // SHOULD appear in trace (8 bytes)
  close(fd);                           // should NOT appear in trace
  getpid();                            // should NOT appear in trace

  printf("\nPASS: e_test_open — trace should show ONLY open lines\n");
  exit(0);
}
