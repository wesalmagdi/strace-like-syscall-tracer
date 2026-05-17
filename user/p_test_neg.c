// p_test2.c — Negative PIDs are rejected by attach_trace()
//
// Run: p_test2
// PASS if: attach_trace(-1, 0) and attach_trace(-999, 0) both return -1

#include "kernel/types.h"
#include "user/user.h"

int main(void)
{
  int r1 = attach_trace(-1, 0);
  int r2 = attach_trace(-999, 0);

  int ok = (r1 == -1 && r2 == -1);
  if(ok)
    printf("PASS: p_test_neg — negative PIDs correctly rejected\n");
  else
    printf("FAIL: p_test_neg — attach_trace(-1)=%d attach_trace(-999)=%d\n", r1, r2);
  exit(ok ? 0 : 1);
}
