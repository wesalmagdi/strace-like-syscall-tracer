#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main()
{
    printf("Starting syscall trace test...\n");

    // trigger some syscalls
    int fd = open("README", 0);
    if(fd < 0){
        printf("open failed\n");
    } else {
        char buf[32];
        read(fd, buf, sizeof(buf));
        close(fd);
    }

    // more syscalls to generate trace noise
    for(int i = 0; i < 5; i++){
        getpid();
        pause(1);
    }

    printf("Test finished\n");
    exit(0);
}
