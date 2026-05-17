// p_test4.c — Init process (PID 1) is protected from attach
//
// Run: p_test4
// PASS if: attach_trace(1, 0) returns -1

#include "kernel/types.h"
#include "user/user.h"

int main(void)
{
  int r = attach_trace(1, 0);
  if(r == -1)
    printf("PASS: p_test_init — init process (PID 1) correctly protected\n");
  else
    printf("FAIL: p_test_init — expected -1, got %d\n", r);
  exit(r == -1 ? 0 : 1);
}
