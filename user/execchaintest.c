#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  char *argv[] = { "execchain_b", 0 };

  getpid();
  exec("execchain_b", argv);

  exit(1);
}