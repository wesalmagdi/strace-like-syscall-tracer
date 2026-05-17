// p_test5.c — Attach to self succeeds
//
// Run: p_test5
// PASS if: attach_trace(getpid(), 0) returns 0

#include "kernel/types.h"
#include "user/user.h"

int main(void)
{
  int mypid = getpid();
  int r = attach_trace(mypid, 0);
  if(r == 0)
    printf("PASS: p_test_self — attach to self (pid=%d) succeeded\n", mypid);
  else
    printf("FAIL: p_test_self — expected 0, got %d\n", r);
  exit(r == 0 ? 0 : 1);
}
