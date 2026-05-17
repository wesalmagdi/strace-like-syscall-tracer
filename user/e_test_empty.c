// btest_all.c — Test 1: No -e flag, trace everything
//
// Run:   strace btest_all
// Expect trace output contains ALL of these lines:
//   N: syscall exec("btest_all", ...) -> ...
//   N: syscall open("README", 0) -> 3
//   N: syscall read(3, ..., 8) -> 8
//   N: syscall write(1, ..., 8) -> 8
//   N: syscall close(3) -> 0
//   N: syscall getpid() -> N
//
// PASS if: all 6 syscall types appear in trace
// FAIL if: any of them is missing

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(void)
{
  char buf[8];

  int fd = open("README", O_RDONLY);
  if(fd < 0){ printf("FAIL: open failed\n"); exit(1); }

  int n = read(fd, buf, 8);
  if(n <= 0){ printf("FAIL: read failed\n"); exit(1); }

  write(1, buf, n);
  close(fd);
  getpid();

  printf("\nPASS: e_test_empty — zero trace lines should appear above\n");
  exit(0);
}
