#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int
main(void)
{
  int pid = getpid();

  write(1, "START\n", 6);

  int fd = open("README", O_RDONLY);
  if(fd >= 0){
    char buf[12];
    int n = read(fd, buf, sizeof(buf));
    if(n > 0){
      write(1, "READ_OK\n", 8);
    }
    close(fd);
  } else {
    write(1, "OPEN_FAIL\n", 10);
  }

  sbrk(0);

  write(1, "END\n", 4);

  // Use pid so compiler does not ignore it.
  if(pid < 0)
    write(1, "BAD_PID\n", 8);

  exit(0);
}
