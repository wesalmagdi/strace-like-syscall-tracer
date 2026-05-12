#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  printf("bgtest pid %d\n", getpid());

  while(1){
    getpid();
    pause(1);
  }

  exit(0);
}
