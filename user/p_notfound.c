// p_test3.c — Non-existent PID returns -1 from attach_trace()
//
// Run: p_test3
// PASS if: attach_trace(9999, 0) returns -1

#include "kernel/types.h"
#include "user/user.h"

int main(void)
{
  int r = attach_trace(9999, 0);
  if(r == -1)
    printf("PASS: p_notfound — non-existent PID correctly returns -1\n");
  else
    printf("FAIL: p_notfound — expected -1, got %d\n", r);
  exit(r == -1 ? 0 : 1);
}
