// btest_empty.c — Test 6: -e trace= (empty filter, trace nothing)
//
// Run:   strace -e trace= btest_empty
// Expect: program output appears normally BUT zero trace lines
//
// PASS if: "PASS: btest_empty" prints AND no syscall lines appear in trace
// FAIL if: any "N: syscall ..." line appears in trace output

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(void)
{
  char buf[8];

  // do a variety of syscalls — none should appear in trace
  int fd = open("README", O_RDONLY);
  if(fd < 0){ printf("FAIL: open failed\n"); exit(1); }

  int n = read(fd, buf, 8);
  if(n <= 0){ printf("FAIL: read failed\n"); exit(1); }

  write(1, buf, n);
  close(fd);
  getpid();

  printf("\nPASS: e_test_all — trace should show exec,open,read,write,close,getpid\n");
  exit(0);
}
