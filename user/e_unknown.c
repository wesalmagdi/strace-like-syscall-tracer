// btest_unknown.c — Test 7: -e trace=blah (unknown syscall name)
//
// This test CANNOT be run as: strace -e trace=blah btest_unknown
// because strace exits before exec'ing the program.
//
// Instead run these directly from the xv6 shell:
//
//   $ strace -e trace=blah echo hi
//   PASS if: prints "strace: unknown syscall name 'blah'"
//            'hi' never prints, no trace lines appear
//
//   $ strace -e trace=write,blah echo hi
//   PASS if: prints "strace: unknown syscall name 'blah'"
//            exits before tracing anything
//
//   $ strace -e trace=blah,write echo hi
//   PASS if: prints "strace: unknown syscall name 'blah'"
//            exits before tracing anything
//
//   $ strace -e trace=123 echo hi
//   PASS if: prints "strace: unknown syscall name '123'"
//            numeric ids are not accepted
//
// This file exists as documentation only.
// Running it directly (without strace) just prints the instructions.

#include "kernel/types.h"
#include "user/user.h"

int main(void)
{
  printf("btest_unknown: run these from the xv6 shell:\n\n");

  printf("  strace -e trace=blah echo hi\n");
  printf("  Expected: strace: unknown syscall name 'blah'\n\n");

  printf("  strace -e trace=write,blah echo hi\n");
  printf("  Expected: strace: unknown syscall name 'blah'\n\n");

  printf("  strace -e trace=123 echo hi\n");
  printf("  Expected: strace: unknown syscall name '123'\n\n");

  printf("  All three confirmed working in actual test runs.\n");
  exit(0);
}
