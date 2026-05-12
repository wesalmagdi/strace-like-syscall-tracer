#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  for(int i = 0; i < 1000; i++)
    getpid();

  for(int i = 0; i < 100; i++)
    sbrk(0);

  exit(0);
}