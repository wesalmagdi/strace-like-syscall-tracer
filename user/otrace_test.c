#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

static void
say(char *s)
{
  write(1, s, strlen(s));
}

int
main(void)
{
  char buf[32];

  say("otrace: start\n");

  getpid();

  int fd = open("README", O_RDONLY);
  read(fd, buf, sizeof(buf));
  close(fd);

  sbrk(0);

  say("otrace: end\n");

  exit(0);
}