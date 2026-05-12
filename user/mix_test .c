#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
  write(1, "A", 1);
  getpid();

  write(1, "B", 1);
  getpid();

  write(1, "\n", 1);
  exit(0);
}