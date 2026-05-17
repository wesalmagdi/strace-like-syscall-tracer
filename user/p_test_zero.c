// p_test1.c — PID 0 is rejected by attach_trace()
//
// Run: p_test1
// PASS if: attach_trace(0, 0) returns -1

#include "kernel/types.h"
#include "user/user.h"

int main(void)
{
  int r = attach_trace(0, 0);
  if(r == -1)
    printf("PASS: p_test_zero — PID 0 correctly rejected\n");
  else
    printf("FAIL: p_test_zero  — expected -1, got %d\n", r);
  exit(r == -1 ? 0 : 1);
}
