#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  char *argv[] = { "execchain_c", 0 };

  getpid();
  exec("execchain_c", argv);

  exit(1);
}