#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  write(1, "A", 1);      // no newline on purpose
  getpid();              // trace line may appear beside A

  write(1, "B", 1);      // no newline on purpose
  getpid();              // trace line may appear beside B

  write(1, "\nDONE\n", 6);

  exit(0);
}
