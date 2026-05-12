#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  char *argv[] = { "/no/such/binary", 0 };

  int r = exec("/no/such/binary", argv);

  printf("failed exec returned %d\n", r);

  exit(9);
}
